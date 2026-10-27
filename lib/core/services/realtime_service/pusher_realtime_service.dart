import 'dart:async';
import 'dart:convert';

import 'package:assab/core/network/api_endpoints.dart';
import 'package:assab/core/services/token_storage_service.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import 'realtime_event.dart';
import 'realtime_service.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const _kTag = 'PusherRealtimeService';
const _kReconnectDelay = Duration(seconds: 3);

/// Set to 0 for unlimited reconnect attempts.
const _kMaxReconnectAttempts = 5;

const _kCompileTimePusherKey = String.fromEnvironment('PUSHER_APP_KEY');
const _kCompileTimePusherCluster = String.fromEnvironment('PUSHER_CLUSTER');

// ---------------------------------------------------------------------------
// Internal channel holder
// ---------------------------------------------------------------------------

/// Holds the typed [StreamController] and [mapper] for a single Pusher channel.
///
/// Errors from [mapper] are forwarded as stream errors rather than thrown,
/// keeping the broadcast stream alive for all other listeners.
class _ChannelEntry<T> {
  _ChannelEntry({required this.mapper})
    : _controller = StreamController<RealtimeEvent<T>>.broadcast();

  final T Function(Map<String, dynamic> json) mapper;
  final StreamController<RealtimeEvent<T>> _controller;

  Stream<RealtimeEvent<T>> get stream => _controller.stream;

  bool get isClosed => _controller.isClosed;

  /// Parses [rawData], applies [mapper], and adds the result to the stream.
  /// Forwards any exception as a stream error instead of throwing.
  void dispatch({required String eventName, required dynamic rawData}) {
    if (isClosed) {
      AppLogger.log(
        'dispatch() called on closed controller for event "$eventName" — ignoring.',
        tag: _kTag,
      );
      return;
    }

    try {
      final json = _parseRawData(rawData);
      final data = mapper(json);
      final event = RealtimeEvent<T>(event: eventName, data: data);
      _controller.add(event);

      AppLogger.log(
        'Event dispatched — event: $eventName, data: $event',
        tag: _kTag,
      );
    } catch (e, stack) {
      AppLogger.log(
        'Dispatch error for event "$eventName" — forwarding as stream error: $e',
        tag: _kTag,
      );
      _controller.addError(e, stack);
    }
  }

  /// Closes the stream controller if not already closed.
  Future<void> close() async {
    if (!isClosed) await _controller.close();
  }
}

// ---------------------------------------------------------------------------
// Service
// ---------------------------------------------------------------------------

@LazySingleton(as: RealtimeService)
class PusherRealtimeService implements RealtimeService {
  PusherRealtimeService({
    required TokenStorageService tokenStorageService,
    required Dio dio,
  }) : _tokenStorageService = tokenStorageService,
       _dio = dio;

  final TokenStorageService _tokenStorageService;

  /// The app-wide Dio instance. Its interceptor automatically attaches
  /// the Authorization header, so [_authorizeChannel] gets auth for free.
  final Dio _dio;

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  bool _connected = false;
  bool _initialized = false;
  int _reconnectAttempts = 0;

  /// Active channel subscriptions keyed by channel name.
  /// Each entry carries its own type parameter, making casts in [subscribe] safe.
  final Map<String, _ChannelEntry<dynamic>> _channels = {};

  // ── Connection API ─────────────────────────────────────────────────────────

  /// Initializes Pusher and opens the connection. Idempotent.
  @override
  Future<void> connect() async {
    if (_connected) {
      AppLogger.log('Already connected — skipping.', tag: _kTag);
      return;
    }
    final ready = await _initPusher();
    if (!ready) {
      return;
    }
    await _connectPusher();
  }

  /// Closes all channel subscriptions and disconnects from Pusher.
  @override
  Future<void> disconnect() async {
    AppLogger.log('Disconnecting.', tag: _kTag);
    try {
      await _closeAllChannels();
      if (_initialized) {
        await _pusher.disconnect();
      }
      _connected = false;
      _initialized = false;
      _reconnectAttempts = 0;
      AppLogger.log('Disconnected.', tag: _kTag);
    } catch (e, stack) {
      _logError('Disconnect failed', e, stack);
    }
  }

  // ── Subscription API ───────────────────────────────────────────────────────

  /// Subscribes to [channel] and returns a typed broadcast stream of events.
  ///
  /// Calling this method twice with the same [channel] returns the existing
  /// stream without creating a duplicate Pusher subscription.
  @override
  Stream<RealtimeEvent<T>> subscribe<T>({
    required String channel,
    required T Function(Map<String, dynamic> json) mapper,
  }) {
    if (_channels.containsKey(channel)) {
      AppLogger.log(
        'Already subscribed to "$channel" — returning existing stream.',
        tag: _kTag,
      );
      return (_channels[channel] as _ChannelEntry<T>).stream;
    }

    final entry = _ChannelEntry<T>(mapper: mapper);
    _channels[channel] = entry;

    if (!_initialized) {
      AppLogger.log(
        'Pusher not initialized — returning idle stream for "$channel".',
        tag: _kTag,
      );
      return entry.stream;
    }

    _pusher.subscribe(
      channelName: channel,
      onEvent: (dynamic raw) {
        if (raw is! PusherEvent) {
          AppLogger.log(
            'Unexpected event type on "$channel": ${raw.runtimeType}',
            tag: _kTag,
          );
          return;
        }
        _onChannelEvent(channel, raw);
      },
    );

    AppLogger.log('Subscribed to channel: "$channel"', tag: _kTag);
    return entry.stream;
  }

  /// Unsubscribes from [channel] and closes its stream.
  @override
  Future<void> unsubscribe(String channel) async {
    if (!_channels.containsKey(channel)) {
      AppLogger.log(
        'Unsubscribe ignored — unknown channel: "$channel".',
        tag: _kTag,
      );
      return;
    }
    try {
      if (_initialized) {
        await _pusher.unsubscribe(channelName: channel);
      }
      await _channels[channel]!.close();
      _channels.remove(channel);
      AppLogger.log('Unsubscribed from "$channel".', tag: _kTag);
    } catch (e, stack) {
      _logError('Unsubscribe failed for "$channel"', e, stack);
    }
  }

  // ── Initialisation ─────────────────────────────────────────────────────────

  /// Configures and initializes the Pusher SDK. Runs once per session.
  /// Returns false when Pusher credentials are not configured in this build.
  Future<bool> _initPusher() async {
    if (_initialized) return true;

    final apiKey = _optionalEnv('PUSHER_APP_KEY', _kCompileTimePusherKey);
    final cluster = _optionalEnv('PUSHER_CLUSTER', _kCompileTimePusherCluster);

    if (apiKey == null || cluster == null) {
      AppLogger.log(
        'Pusher credentials not configured — realtime disabled for this session.',
        tag: _kTag,
      );
      return false;
    }

    await _pusher.init(
      apiKey: apiKey,
      cluster: cluster,
      onAuthorizer: _authorizeChannel,
      onConnectionStateChange: _onConnectionStateChange,
      onError: _onConnectionError,
      onSubscriptionSucceeded: _onSubscriptionSucceeded,
      onSubscriptionError: _onSubscriptionError,
      onSubscriptionCount: _onSubscriptionCount,
      onDecryptionFailure: _onDecryptionFailure,
      onEvent: _onGlobalEvent,
    );

    _initialized = true;
    AppLogger.log(
      'Pusher initialized (auth endpoint: ${ApiEndpoint.pusherAuth}).',
      tag: _kTag,
    );
    return true;
  }

  // ── Private-channel authorization ─────────────────────────────────────────

  /// Authorizes a private or presence channel with the Laravel broadcasting
  /// server. Called by the Pusher SDK before each private/presence subscription.
  ///
  /// Returns a map containing at minimum `{ "auth": "<signed-token>" }`,
  /// or null on failure — which causes the SDK to emit a subscription error.
  ///
  /// Presence channels receive both `auth` and `channel_data` from the server,
  /// so the full response body is returned as-is.
  Future<dynamic> _authorizeChannel(
    String channelName,
    String socketId,
    dynamic options,
  ) async {
    AppLogger.log(
      'Authorizing channel "$channelName" for socket "$socketId".',
      tag: _kTag,
    );

    final token = await _tokenStorageService.getAccessToken();

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoint.pusherAuth,
        data: {'socket_id': socketId, 'channel_name': channelName},
        options: Options(
          contentType: 'application/json',
          responseType: ResponseType.json,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final body = response.data;

      if (body == null || body['auth'] == null) {
        AppLogger.log(
          'Authorization response missing "auth" field for "$channelName". Response: $body',
          tag: _kTag,
        );
        return null;
      }

      AppLogger.log('Channel "$channelName" authorized.', tag: _kTag);
      return body;
    } on DioException catch (e) {
      AppLogger.log(
        'Authorization request failed for "$channelName" '
        '— status: ${e.response?.statusCode}, message: ${e.message}',
        tag: _kTag,
      );
      return null;
    } catch (e, stack) {
      _logError('Unexpected authorization error for "$channelName"', e, stack);
      return null;
    }
  }

  /// Opens the Pusher connection and resets the reconnect counter on success.
  Future<void> _connectPusher() async {
    try {
      await _pusher.connect();
      _connected = true;
      _reconnectAttempts = 0;
      AppLogger.log('Connected.', tag: _kTag);
    } catch (e, stack) {
      _logError('Connection failed', e, stack);
      await _maybeReconnect();
    }
  }

  // ── Auto-reconnect ─────────────────────────────────────────────────────────

  /// Schedules a reconnect attempt after [_kReconnectDelay].
  /// Stops after [_kMaxReconnectAttempts] failures (ignored if 0).
  Future<void> _maybeReconnect() async {
    if (_kMaxReconnectAttempts > 0 &&
        _reconnectAttempts >= _kMaxReconnectAttempts) {
      AppLogger.log(
        'Max reconnect attempts ($_kMaxReconnectAttempts) reached — giving up.',
        tag: _kTag,
      );
      return;
    }

    _reconnectAttempts++;
    final attempt = _kMaxReconnectAttempts > 0
        ? '$_reconnectAttempts / $_kMaxReconnectAttempts'
        : '$_reconnectAttempts';
    AppLogger.log('Reconnect attempt $attempt.', tag: _kTag);

    await Future<void>.delayed(_kReconnectDelay);
    await _connectPusher();
  }

  // ── Channel tear-down ──────────────────────────────────────────────────────

  /// Closes all active channel stream controllers and clears the registry.
  Future<void> _closeAllChannels() async {
    for (final entry in _channels.values) {
      await entry.close();
    }
    _channels.clear();
  }

  // ── Per-channel event routing ──────────────────────────────────────────────

  /// Routes an inbound Pusher event to the matching channel entry for dispatch.
  /// Skips internal Pusher events and frames with null/empty names or payloads.
  void _onChannelEvent(String channel, PusherEvent event) {
    final raw = event.data;
    final eventName = event.eventName;

    try {
      final formatted = event.data is String
          ? const JsonEncoder.withIndent('  ').convert(jsonDecode(raw))
          : const JsonEncoder.withIndent('  ').convert(raw);

      AppLogger.log(
        'Event received — channel: $channel, event: $eventName, raw: $formatted',
        tag: _kTag,
      );
    } catch (e) {
      AppLogger.log(
        'Event received (unformatted) — channel: $channel, event: $eventName, raw: $raw',
        tag: _kTag,
      );
    }

    if (_isPusherInternalEvent(eventName)) {
      AppLogger.log(
        'Internal event "$eventName" on "$channel" — skipping.',
        tag: _kTag,
      );
      return;
    }

    if (eventName.isEmpty) {
      AppLogger.log(
        'Null or empty event name on "$channel" — skipping.',
        tag: _kTag,
      );
      return;
    }

    if (raw == null || (raw is Map && raw.isEmpty)) {
      AppLogger.log(
        'Empty payload for "$eventName" on "$channel" — skipping.',
        tag: _kTag,
      );
      return;
    }

    _channels[channel]?.dispatch(eventName: eventName, rawData: raw);
  }

  // ── Pusher SDK callbacks ───────────────────────────────────────────────────

  /// Logs connection state transitions and triggers reconnect on unexpected
  /// disconnections.
  void _onConnectionStateChange(String? currentState, String? previousState) {
    AppLogger.log(
      'Connection state changed: $previousState -> $currentState',
      tag: _kTag,
    );

    if (currentState == 'DISCONNECTED' && _connected) {
      _connected = false;
      AppLogger.log(
        'Unexpected disconnection — scheduling reconnect.',
        tag: _kTag,
      );
      _maybeReconnect();
    }
  }

  void _onConnectionError(String? message, int? code, dynamic exception) {
    AppLogger.log(
      'Connection error — message: $message, code: $code, exception: $exception',
      tag: _kTag,
    );
  }

  void _onSubscriptionSucceeded(String channelName, dynamic data) {
    AppLogger.log(
      'Subscription succeeded — channel: $channelName, data: $data',
      tag: _kTag,
    );
  }

  void _onSubscriptionError(String? message, dynamic error) {
    AppLogger.log(
      'Subscription error — message: $message, error: $error',
      tag: _kTag,
    );
  }

  void _onSubscriptionCount(String channelName, int count) {
    AppLogger.log(
      'Subscription count updated — channel: $channelName, count: $count',
      tag: _kTag,
    );
  }

  void _onDecryptionFailure(String? event, String? reason) {
    AppLogger.log(
      'Decryption failure — event: $event, reason: $reason',
      tag: _kTag,
    );
  }

  /// Fires for every event on every channel before per-channel routing.
  void _onGlobalEvent(PusherEvent event) {
    try {
      final formatted = event.data is String
          ? const JsonEncoder.withIndent('  ').convert(jsonDecode(event.data))
          : const JsonEncoder.withIndent('  ').convert(event.data);

      AppLogger.log(
        'Global event — channel: ${event.channelName}, event: ${event.eventName}, data:\n$formatted',
        tag: _kTag,
      );
    } catch (e) {
      AppLogger.log(
        'Global event (unformatted) — channel: ${event.channelName}, event: ${event.eventName}, data: ${event.data}',
        tag: _kTag,
      );
    }
  }

  // ── Utilities ──────────────────────────────────────────────────────────────

  /// Reads an optional Pusher configuration key from `.env` or `--dart-define`.
  String? _optionalEnv(String key, String compileTimeFallback) {
    if (dotenv.isInitialized) {
      final value = dotenv.env[key]?.trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    final fallback = compileTimeFallback.trim();
    return fallback.isEmpty ? null : fallback;
  }

  /// Returns true for Pusher system events that carry no application payload.
  bool _isPusherInternalEvent(String? name) {
    if (name == null) return true;
    return name.startsWith('pusher:') || name.startsWith('pusher_internal:');
  }

  void _logError(String context, Object error, StackTrace stack) {
    AppLogger.log('$context — error: $error, stack: $stack', tag: _kTag);
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Normalizes a raw Pusher payload into [Map<String, dynamic>].
///
/// Accepts a JSON-encoded [String] or an existing [Map].
/// Throws [ArgumentError] for any other type.
Map<String, dynamic> _parseRawData(dynamic raw) {
  if (raw is String) {
    final decoded = jsonDecode(raw);
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw ArgumentError(
      'Expected a JSON object string, got ${decoded.runtimeType}: $decoded',
    );
  }
  if (raw is Map) return Map<String, dynamic>.from(raw);
  throw ArgumentError(
    'Unsupported Pusher payload type ${raw.runtimeType} — '
    'expected a JSON-encoded String or a Map.',
  );
}
