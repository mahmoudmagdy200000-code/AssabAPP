import 'dart:math';
import 'package:assab/core/services/user_type_service.dart';
import 'package:dio/dio.dart';

/// State of an individual user intent
enum IntentState {
  inFlight,
  retryable,
  completed,
  failed,
}

/// Represents an explicit, intent-owned idempotency lifecycle entry
class UserIntent {
  final String key;
  final DateTime createdAt;
  IntentState state;

  UserIntent(this.key, {this.state = IntentState.inFlight})
      : createdAt = DateTime.now();

  bool get isExpired =>
      DateTime.now().difference(createdAt) > IdempotencyScopeManager.defaultTtl;
}

/// Manages idempotency keys across logical financial operations and user-initiated retries.
class IdempotencyScopeManager {
  static final Map<String, UserIntent> _activeIntents = {};
  static final Set<String> _completedKeys = {};
  static const Duration defaultTtl = Duration(minutes: 5);

  static String _payloadFingerprint(dynamic data) {
    if (data == null) return '';
    if (data is Map) {
      final sortedKeys = data.keys.map((k) => k.toString()).toList()..sort();
      final buffer = StringBuffer();
      for (final k in sortedKeys) {
        buffer.write('$k=${data[k]};');
      }
      return buffer.toString().hashCode.toRadixString(16);
    }
    if (data is FormData) {
      final fields = data.fields.map((e) => '${e.key}=${e.value}').toList()..sort();
      return fields.join(';').hashCode.toRadixString(16);
    }
    return data.toString().hashCode.toRadixString(16);
  }

  /// Derive or obtain a logical scope identifier from the request.
  /// Scoped to authenticated actor, method, path, and concrete payload.
  static String deriveScope(
    String method,
    String path, [
    String? explicitScope,
    dynamic data,
  ]) {
    if (explicitScope != null && explicitScope.isNotEmpty) {
      return explicitScope;
    }
    final normalizedPath = path.replaceFirst(RegExp(r'^/'), '');
    final actor = UserTypeService.selectedUserType?.value ?? 'actor';
    final payloadHash = _payloadFingerprint(data);
    final payloadPart = payloadHash.isNotEmpty ? ':$payloadHash' : '';
    return '$actor:${method.toUpperCase()}:$normalizedPath$payloadPart';
  }

  /// Start a new explicit user intent for a logical scope.
  /// Generates a fresh RFC4122 v4 UUID (or uses [explicitKey]), updating the timestamp.
  static String startNewIntent(String scope, [String? explicitKey]) {
    final key = explicitKey ?? generateUuidV4();
    _activeIntents[scope] = UserIntent(key, state: IntentState.inFlight);
    return key;
  }

  /// Mark the intent for this scope and key as completed on 2xx response.
  /// The key is recorded in [_completedKeys] so it can never be re-used or replayed across separate submissions.
  static void markIntentCompleted(String scope, [String? key]) {
    final intent = _activeIntents[scope];
    if (intent != null) {
      intent.state = IntentState.completed;
      _completedKeys.add(intent.key);
    }
    if (key != null) {
      _completedKeys.add(key);
    }
    _activeIntents.remove(scope);
  }

  /// Clears the intent and stored key for a scope.
  static void clearIntent(String scope) {
    _activeIntents.remove(scope);
  }

  /// Alias for clearIntent to maintain backward compatibility.
  static void clearScope(String scope) => clearIntent(scope);

  /// Check if a scope has an active and retryable key.
  static bool hasActiveKey(String scope) {
    final intent = _activeIntents[scope];
    if (intent == null) return false;
    if (intent.isExpired ||
        intent.state == IntentState.completed ||
        intent.state == IntentState.failed ||
        _completedKeys.contains(intent.key)) {
      _activeIntents.remove(scope);
      return false;
    }
    return true;
  }

  /// Get the active key for an in-flight or retryable user intent, or generate a fresh one
  /// if starting a separate submission. Stale successes and failed attempts never replay.
  static String getOrCreateKey(String scope) {
    final intent = _activeIntents[scope];
    if (intent != null && !intent.isExpired) {
      if (intent.state == IntentState.completed ||
          intent.state == IntentState.failed ||
          _completedKeys.contains(intent.key)) {
        _activeIntents.remove(scope);
        return startNewIntent(scope);
      }
      return intent.key;
    }
    return startNewIntent(scope);
  }

  /// Mark intent as retryable after an unresolved network error (timeout / 502 / 504 / 409 in-progress).
  static void markIntentRetryable(String scope) {
    final intent = _activeIntents[scope];
    if (intent != null && intent.state != IntentState.completed) {
      intent.state = IntentState.retryable;
    }
  }

  /// Set or override key for an explicit scope
  static void setKey(String scope, String key) {
    startNewIntent(scope, key);
  }

  /// Reset all stored keys and completed set
  static void resetAll() {
    _activeIntents.clear();
    _completedKeys.clear();
  }

  /// Generate RFC4122 v4 UUID
  static String generateUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }
}

/// Interceptor attaching RFC4122 v4 UUID Idempotency-Key headers on mutating financial requests.
/// Reuses the same key across separate RequestOptions instances if retrying the same uncertain operation.
class IdempotencyInterceptor extends Interceptor {
  static final RegExp _financialPathRegex = RegExp(
    r'(shifts/[^/]+/(end|start-handover|end-with-handover|reassign-with-handover|handover(/approve|/accept|/reject)?)|shifts/end|replace-recipient|handover-receipts|custody/handover|shift-transfers|shift-transfer-attempts)',
    caseSensitive: false,
  );

  static String generateKey() => IdempotencyScopeManager.generateUuidV4();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() == 'POST') {
      final isFinancial = _financialPathRegex.hasMatch(options.path);
      if (isFinancial) {
        final scope = IdempotencyScopeManager.deriveScope(
          options.method,
          options.path,
          options.extra['idempotency_scope'] as String?,
          options.data,
        );

        String? key;
        if (options.extra['force_new_intent'] == true) {
          key = IdempotencyScopeManager.startNewIntent(scope);
        } else {
          key = options.extra['idempotency_key'] as String? ??
              options.headers['Idempotency-Key'] as String?;

          if (key == null || key.isEmpty) {
            key = IdempotencyScopeManager.getOrCreateKey(scope);
          } else {
            IdempotencyScopeManager.setKey(scope, key);
          }
        }

        options.extra['idempotency_key'] = key;
        options.extra['idempotency_scope'] = scope;
        options.headers['Idempotency-Key'] = key;
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final scope = response.requestOptions.extra['idempotency_scope'] as String? ??
        IdempotencyScopeManager.deriveScope(
          response.requestOptions.method,
          response.requestOptions.path,
          null,
          response.requestOptions.data,
        );
    final key = response.requestOptions.extra['idempotency_key'] as String? ??
        response.requestOptions.headers['Idempotency-Key'] as String?;

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      IdempotencyScopeManager.markIntentCompleted(scope, key);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final responseData = err.response?.data;
    final scope = err.requestOptions.extra['idempotency_scope'] as String? ??
        IdempotencyScopeManager.deriveScope(
          err.requestOptions.method,
          err.requestOptions.path,
          null,
          err.requestOptions.data,
        );

    final errorCode = responseData is Map ? responseData['code']?.toString() : null;
    final errorMessage = responseData is Map ? responseData['message']?.toString() : null;

    final isIdempotencyExpiredOrReused = errorCode == 'IDEMPOTENCY_KEY_REUSED' ||
        errorCode == 'RESPONSE_EXPIRED' ||
        errorCode == 'SCOPE_CHANGED' ||
        errorCode == 'PAYLOAD_MISMATCH' ||
        (errorMessage?.contains('idempotency') == true &&
            (errorMessage?.contains('reused') == true ||
                errorMessage?.contains('expired') == true ||
                errorMessage?.contains('scope') == true));

    final isIdempotencyInProgress = status == 409 &&
        !isIdempotencyExpiredOrReused &&
        (errorCode == 'IDEMPOTENCY_IN_PROGRESS' ||
            (errorMessage?.toLowerCase().contains('in progress') == true));

    final isUncertain = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        status == 504 ||
        status == 502;

    final hasRetryAfter = err.response?.headers.value('retry-after') != null;

    // Only preserve scope key if operation is explicitly in-progress on the server (to allow polling/settling)
    // or if an uncertain network timeout occurred (without explicit key expiry/rejection).
    final shouldPreserveScope = !isIdempotencyExpiredOrReused &&
        (isIdempotencyInProgress || (isUncertain && !isIdempotencyExpiredOrReused) || (hasRetryAfter && isIdempotencyInProgress));

    if (shouldPreserveScope) {
      IdempotencyScopeManager.markIntentRetryable(scope);
    } else {
      IdempotencyScopeManager.clearIntent(scope);
    }

    handler.next(err);
  }
}
