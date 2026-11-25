import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:assab/core/services/user_type_service.dart';
import 'package:dio/dio.dart';

/// State of an individual user intent
enum IntentState {
  inFlight,
  retryable,
  completed,
  failed,
}

/// Represents an explicit, intent-owned idempotency lifecycle entry.
class UserIntent {
  final String key;
  final String scope;
  final int sessionEpoch;
  final DateTime createdAt;
  IntentState state;

  UserIntent(
    this.key, {
    required this.scope,
    required this.sessionEpoch,
    this.state = IntentState.inFlight,
  }) : createdAt = DateTime.now();

  /// A retryable (unresolved) intent never expires by TTL: its outcome is unknown,
  /// so silently minting a new key could duplicate a financial command. It is
  /// released only by a definitive response or explicit reconciliation.
  bool get isExpired =>
      state != IntentState.retryable &&
      DateTime.now().difference(createdAt) > IdempotencyScopeManager.defaultTtl;
}

/// Pure-Dart streaming SHA-256 (FIPS 180-4) so MultipartFile streams can be
/// hashed chunk-by-chunk with O(1) memory and zero extra pub dependencies.
class _StreamingSha256 {
  static const List<int> _k = [
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1,
    0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786,
    0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147,
    0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b,
    0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a,
    0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
  ];

  final Uint32List _h = Uint32List.fromList([
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
  ]);
  final Uint8List _block = Uint8List(64);
  final Uint32List _w = Uint32List(64);
  int _blockLen = 0;
  int _totalBytes = 0;

  void add(List<int> data) {
    _totalBytes += data.length;
    var offset = 0;
    while (offset < data.length) {
      final take = min(64 - _blockLen, data.length - offset);
      _block.setRange(_blockLen, _blockLen + take, data, offset);
      _blockLen += take;
      offset += take;
      if (_blockLen == 64) {
        _compress();
        _blockLen = 0;
      }
    }
  }

  static int _rotr(int x, int n) => ((x >>> n) | (x << (32 - n))) & 0xffffffff;

  void _compress() {
    for (var i = 0; i < 16; i++) {
      final j = i * 4;
      _w[i] = (_block[j] << 24) |
          (_block[j + 1] << 16) |
          (_block[j + 2] << 8) |
          _block[j + 3];
    }
    for (var i = 16; i < 64; i++) {
      final w15 = _w[i - 15];
      final w2 = _w[i - 2];
      final s0 = _rotr(w15, 7) ^ _rotr(w15, 18) ^ (w15 >>> 3);
      final s1 = _rotr(w2, 17) ^ _rotr(w2, 19) ^ (w2 >>> 10);
      _w[i] = (_w[i - 16] + s0 + _w[i - 7] + s1) & 0xffffffff;
    }

    var a = _h[0], b = _h[1], c = _h[2], d = _h[3];
    var e = _h[4], f = _h[5], g = _h[6], h = _h[7];

    for (var i = 0; i < 64; i++) {
      final bigS1 = _rotr(e, 6) ^ _rotr(e, 11) ^ _rotr(e, 25);
      final ch = (e & f) ^ ((~e & 0xffffffff) & g);
      final temp1 = (h + bigS1 + ch + _k[i] + _w[i]) & 0xffffffff;
      final bigS0 = _rotr(a, 2) ^ _rotr(a, 13) ^ _rotr(a, 22);
      final maj = (a & b) ^ (a & c) ^ (b & c);
      final temp2 = (bigS0 + maj) & 0xffffffff;

      h = g;
      g = f;
      f = e;
      e = (d + temp1) & 0xffffffff;
      d = c;
      c = b;
      b = a;
      a = (temp1 + temp2) & 0xffffffff;
    }

    _h[0] = (_h[0] + a) & 0xffffffff;
    _h[1] = (_h[1] + b) & 0xffffffff;
    _h[2] = (_h[2] + c) & 0xffffffff;
    _h[3] = (_h[3] + d) & 0xffffffff;
    _h[4] = (_h[4] + e) & 0xffffffff;
    _h[5] = (_h[5] + f) & 0xffffffff;
    _h[6] = (_h[6] + g) & 0xffffffff;
    _h[7] = (_h[7] + h) & 0xffffffff;
  }

  String digestHex() {
    final bitLen = _totalBytes * 8;
    add(const [0x80]);
    if (_blockLen > 56) {
      add(Uint8List(64 - _blockLen));
    }
    if (_blockLen < 56) {
      add(Uint8List(56 - _blockLen));
    }
    final lenBytes = Uint8List(8);
    var v = bitLen;
    for (var i = 7; i >= 0; i--) {
      lenBytes[i] = v & 0xff;
      v = v ~/ 256;
    }
    add(lenBytes);

    final sb = StringBuffer();
    for (final word in _h) {
      sb.write(word.toRadixString(16).padLeft(8, '0'));
    }
    return sb.toString();
  }

  static String hashString(String input) {
    final h = _StreamingSha256();
    h.add(utf8.encode(input));
    return h.digestHex();
  }
}

/// Manages idempotency keys across logical financial operations and user-initiated retries.
///
/// Active intents are tracked per unique `key` (not overwritten per scope) so concurrent
/// identical requests complete/fail independently without cancelling one another.
class IdempotencyScopeManager {
  static final Map<String, UserIntent> _intentsByKey = {};
  static final Map<String, String> _latestKeyByScope = {};
  static final Set<String> _completedKeys = {};
  static const Duration defaultTtl = Duration(minutes: 5);
  static const int _oneShotCacheCapBytes = 65536;

  /// Per-user-action intent ids whose last attempt had an unknown outcome
  /// (timeout / 502 / 504 / IDEMPOTENCY_IN_PROGRESS). Cleared on any definitive result.
  static final Set<String> _unresolvedIntentIds = {};

  /// Non-reversible digest of the logical authenticated session. Token rotation does not
  /// change it; explicit successful login and logout establish lifecycle boundaries.
  static String _sessionDigest = '';
  static int _sessionEpoch = 0;

  static int get sessionEpoch => _sessionEpoch;

  static String _digestToken(String raw) =>
      _StreamingSha256.hashString('assab-session:$raw').substring(0, 16);

  /// Bootstraps an unknown session once for an already-authenticated cold app start.
  /// Later credential changes are not treated as account/session changes. In-memory
  /// intents do not survive process restart, so a token here cannot restore old retries.
  static void bindSession(String? token) {
    final normalized = token?.trim() ?? '';
    if (normalized.isEmpty || _sessionDigest.isNotEmpty) return;
    _sessionDigest = _digestToken(normalized);
    _sessionEpoch++;
  }

  /// Establish a new logical session from a trusted successful-auth response.
  /// A fresh nonce ensures logging into the same account still creates a boundary.
  static void startSession({
    required String principalType,
    required String principalId,
  }) {
    final type = principalType.trim();
    final id = principalId.trim();
    if (type.isEmpty || id.isEmpty) {
      throw ArgumentError('Authenticated session identity is incomplete');
    }
    _intentsByKey.clear();
    _latestKeyByScope.clear();
    _completedKeys.clear();
    _unresolvedIntentIds.clear();
    _sessionEpoch++;
    _sessionDigest = _StreamingSha256.hashString(
      'assab-session:$type:$id:${generateUuidV4()}',
    ).substring(0, 16);
  }

  static bool isIntentUnresolved(String intentId) =>
      _unresolvedIntentIds.contains(intentId);

  static void markIntentUnresolved(String intentId) =>
      _unresolvedIntentIds.add(intentId);

  /// Explicit reconciliation / abandonment of a user action.
  static void resolveIntent(String intentId) =>
      _unresolvedIntentIds.remove(intentId);

  static String _serializeMap(Map map) {
    final sortedKeys = map.keys.map((k) => k.toString()).toList()..sort();
    final buffer = StringBuffer('{');
    for (final k in sortedKeys) {
      final val = map[k];
      buffer.write('$k:');
      if (val is Map) {
        buffer.write(_serializeMap(val));
      } else if (val is Iterable) {
        buffer.write('[${val.map((e) => e is Map ? _serializeMap(e) : e.toString()).join(',')}]');
      } else {
        buffer.write(val.toString());
      }
      buffer.write(';');
    }
    buffer.write('}');
    return buffer.toString();
  }

  static String _payloadFingerprint(dynamic data) {
    if (data == null) return '';
    if (data is Map) {
      return _StreamingSha256.hashString(_serializeMap(data)).substring(0, 16);
    }
    if (data is FormData) {
      final fields = data.fields.map((e) => '${e.key}=${e.value}').toList()..sort();
      final files = data.files
          .map((e) => '${e.key}:${e.value.filename ?? ''}:${e.value.length}')
          .toList()
        ..sort();
      return _StreamingSha256.hashString('${fields.join(';')}|${files.join(';')}').substring(0, 16);
    }
    return _StreamingSha256.hashString(data.toString()).substring(0, 16);
  }

  /// Async content-aware fingerprint for FormData (streams MultipartFile bytes
  /// chunk-by-chunk into SHA-256 without consuming reusable streams or buffering large files).
  static Future<String> _formDataContentFingerprint(FormData data) async {
    final fields = data.fields.map((e) => '${e.key}=${e.value}').toList()..sort();
    final fileParts = <String>[];

    for (var i = 0; i < data.files.length; i++) {
      final entry = data.files[i];
      final file = entry.value;
      final digest = await _hashAndPreserveMultipart(data, i, file);
      fileParts.add('${entry.key}:${file.filename ?? ''}:${file.length}:$digest');
    }
    fileParts.sort();
    return _StreamingSha256.hashString('${fields.join(';')}|${fileParts.join(';')}').substring(0, 16);
  }

  static Future<String> _hashAndPreserveMultipart(
    FormData formData,
    int index,
    MultipartFile file,
  ) async {
    final sha = _StreamingSha256();
    final smallBuffer = BytesBuilder(copy: false);
    var total = 0;

    try {
      final clone = file.clone();
      await for (final chunk in clone.finalize()) {
        sha.add(chunk);
        total += chunk.length;
        if (total <= _oneShotCacheCapBytes) {
          smallBuffer.add(chunk);
        }
      }
      final digest = sha.digestHex();

      // If this is a <= 64 KB upload, verify a second clone can still be opened so
      // deprecated single-subscription one-shot `MultipartFile(stream, len)` uploads
      // never crash later in the HTTP adapter with "Stream has already been listened to".
      if (total <= _oneShotCacheCapBytes) {
        try {
          final probe = file.clone().finalize().listen((_) {});
          await probe.cancel();
        } on StateError {
          formData.files[index] = MapEntry(
            formData.files[index].key,
            MultipartFile.fromBytes(
              smallBuffer.takeBytes(),
              filename: file.filename,
              contentType: file.contentType,
              headers: file.headers,
            ),
          );
        }
      }

      return digest;
    } catch (_) {
      return 'meta:${file.filename ?? ''}:${file.length}';
    }
  }

  static String _normalizedQuery(Map<String, dynamic>? queryParameters) {
    if (queryParameters == null || queryParameters.isEmpty) return '';
    final keys = queryParameters.keys.map((k) => k.toString()).toList()..sort();
    return '?${keys.map((k) => '$k=${queryParameters[k]}').join('&')}';
  }

  /// Derive or obtain a logical scope identifier from the request.
  /// Scoped to authenticated actor/session digest (never raw token), method, path+query, and payload.
  static String deriveScope(
    String method,
    String path, [
    String? explicitScope,
    dynamic data,
    String? intentId,
    Map<String, dynamic>? queryParameters,
    String? authHeader,
    String? precomputedPayloadHash,
  ]) {
    if (explicitScope != null && explicitScope.isNotEmpty) {
      return explicitScope;
    }
    final normalizedPath = path.replaceFirst(RegExp(r'^/'), '');
    final queryPart = _normalizedQuery(queryParameters);
    final actor = UserTypeService.selectedUserType?.value ?? 'actor';
    final sessionPart = _sessionDigest.isNotEmpty
        ? ':sess=$_sessionDigest'
        : (authHeader != null && authHeader.isNotEmpty)
            ? ':sess=${_digestToken(authHeader)}'
            : '';
    final payloadHash = precomputedPayloadHash ?? _payloadFingerprint(data);
    final payloadPart = payloadHash.isNotEmpty ? ':$payloadHash' : '';
    final intentPart =
        (intentId != null && intentId.isNotEmpty) ? ':intent=$intentId' : '';
    return '$actor$sessionPart:${method.toUpperCase()}:$normalizedPath$queryPart$payloadPart$intentPart';
  }

  /// Start a new explicit user intent for a logical scope.
  /// Generates a fresh RFC4122 v4 UUID (or uses [explicitKey]), isolated per key.
  static String startNewIntent(String scope, [String? explicitKey]) {
    final key = explicitKey ?? generateUuidV4();
    _intentsByKey[key] = UserIntent(
      key,
      scope: scope,
      sessionEpoch: _sessionEpoch,
      state: IntentState.inFlight,
    );
    _latestKeyByScope[scope] = key;
    return key;
  }

  /// Mark ONLY the matching [key] (or latest key in [scope] when key omitted) completed.
  static void markIntentCompleted(String scope, [String? key]) {
    final targetKey = key ?? _latestKeyByScope[scope];
    if (targetKey == null) return;

    final intent = _intentsByKey[targetKey];
    if (intent != null && intent.scope == scope) {
      intent.state = IntentState.completed;
      _intentsByKey.remove(targetKey);
    }
    _completedKeys.add(targetKey);
    if (_latestKeyByScope[scope] == targetKey) {
      _latestKeyByScope.remove(scope);
    }
  }

  /// Clears ONLY the matching [key] (or latest key in [scope] when omitted).
  static void clearIntent(String scope, [String? key]) {
    final targetKey = key ?? _latestKeyByScope[scope];
    if (targetKey == null) return;

    final intent = _intentsByKey[targetKey];
    if (intent != null && intent.scope == scope) {
      _intentsByKey.remove(targetKey);
    }
    if (_latestKeyByScope[scope] == targetKey) {
      _latestKeyByScope.remove(scope);
    }
  }

  /// Alias for clearIntent to maintain backward compatibility.
  static void clearScope(String scope) => clearIntent(scope);

  /// Check if a scope has a currently active (in-flight or retryable) intent.
  static bool hasActiveKey(String scope) {
    final key = _latestKeyByScope[scope];
    if (key == null) return false;
    final intent = _intentsByKey[key];
    if (intent == null ||
        intent.isExpired ||
        intent.sessionEpoch != _sessionEpoch ||
        intent.state == IntentState.completed ||
        intent.state == IntentState.failed ||
        _completedKeys.contains(intent.key)) {
      _intentsByKey.remove(key);
      _latestKeyByScope.remove(scope);
      return false;
    }
    return true;
  }

  /// True when a specific [key] is still registered and active/retryable in current session.
  static bool hasKeyActive(String key) {
    final intent = _intentsByKey[key];
    if (intent == null ||
        intent.isExpired ||
        intent.sessionEpoch != _sessionEpoch ||
        intent.state == IntentState.completed ||
        intent.state == IntentState.failed ||
        _completedKeys.contains(key)) {
      return false;
    }
    return true;
  }

  /// Return a retryable [retryKey] if it belongs to the current session & [scope], else null.
  static String? getRetryableKey(String retryKey, String scope) {
    final intent = _intentsByKey[retryKey];
    if (intent != null &&
        intent.sessionEpoch == _sessionEpoch &&
        intent.scope == scope &&
        intent.state == IntentState.retryable &&
        !_completedKeys.contains(retryKey)) {
      return intent.key;
    }
    return null;
  }

  /// Get the active key for an in-flight or retryable user intent, or generate a fresh one.
  static String getOrCreateKey(String scope, {bool reuseInFlight = true}) {
    final currentKey = _latestKeyByScope[scope];
    final intent = currentKey != null ? _intentsByKey[currentKey] : null;
    if (intent != null && !intent.isExpired && intent.sessionEpoch == _sessionEpoch) {
      if (intent.state == IntentState.completed ||
          intent.state == IntentState.failed ||
          (!reuseInFlight && intent.state == IntentState.inFlight) ||
          _completedKeys.contains(intent.key)) {
        return startNewIntent(scope);
      }
      return intent.key;
    }
    return startNewIntent(scope);
  }

  /// Mark ONLY [key] (or latest in [scope]) retryable after an unresolved error.
  static void markIntentRetryable(String scope, [String? key]) {
    final targetKey = key ?? _latestKeyByScope[scope];
    if (targetKey == null) return;
    final intent = _intentsByKey[targetKey];
    if (intent != null &&
        intent.scope == scope &&
        intent.sessionEpoch == _sessionEpoch &&
        intent.state != IntentState.completed) {
      intent.state = IntentState.retryable;
      _latestKeyByScope[scope] = targetKey;
    }
  }

  /// Set or override key for an explicit scope.
  static void setKey(String scope, String key) {
    startNewIntent(scope, key);
  }

  /// Reset all stored keys, completed set, and unresolved intents.
  static void resetAll() {
    _intentsByKey.clear();
    _latestKeyByScope.clear();
    _completedKeys.clear();
    _unresolvedIntentIds.clear();
    _sessionDigest = '';
    _sessionEpoch++;
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
/// Executes synchronously for JSON/empty bodies (preserving sync callers) and asynchronously
/// for multipart `FormData` with files to hash content bytes without buffering large files.
class IdempotencyInterceptor extends Interceptor {
  static final RegExp _financialPathRegex = RegExp(
    r'(shifts/[^/]+/(end|start-handover|end-with-handover|reassign-with-handover|handover(/approve|/accept|/reject)?)|shifts/end|replace-recipient|handover-receipts|custody/handover|shift-transfers|shift-transfer-attempts|branch-manager/expenses/(quick-cash|single-invoice|grouped-invoice|pre-approval)|purchase/(orders(?!/compare-prices(?:\?|$))|pending|receiving|returns)|recurring-orders)',
    caseSensitive: false,
  );

  static final RegExp _purchaseOrRecurringRegex = RegExp(
    r'(purchase/(orders|pending|receiving|returns)|recurring-orders)',
    caseSensitive: false,
  );

  static const Set<String> _mutatingMethods = {'POST', 'PUT', 'PATCH', 'DELETE'};

  static String generateKey() => IdempotencyScopeManager.generateUuidV4();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_mutatingMethods.contains(options.method.toUpperCase()) ||
        !_financialPathRegex.hasMatch(options.path)) {
      handler.next(options);
      return;
    }

    final data = options.data;
    if (data is FormData && data.files.isNotEmpty) {
      IdempotencyScopeManager._formDataContentFingerprint(data).then((fileHash) {
        _attachAndContinue(options, handler, precomputedPayloadHash: fileHash);
      });
      return;
    }

    _attachAndContinue(options, handler);
  }

  void _attachAndContinue(
    RequestOptions options,
    RequestInterceptorHandler handler, {
    String? precomputedPayloadHash,
  }) {
    final explicitScope = options.extra['idempotency_scope'] as String?;
    final intentId = options.extra['idempotency_intent_id'] as String? ??
        IdempotencyIntent.current;
    final authHeader = options.headers['Authorization']?.toString();
    final scope = IdempotencyScopeManager.deriveScope(
      options.method,
      options.path,
      explicitScope,
      options.data,
      intentId,
      options.queryParameters,
      authHeader,
      precomputedPayloadHash,
    );

    String? key;
    if (options.extra['force_new_intent'] == true) {
      key = IdempotencyScopeManager.startNewIntent(scope);
    } else if (options.extra['retry_idempotency_key'] is String) {
      final candidate = options.extra['retry_idempotency_key'] as String;
      key = IdempotencyScopeManager.getRetryableKey(candidate, scope);
      if (key == null) {
        handler.reject(DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          message: 'Retry identity is not available in the current session.',
        ));
        return;
      }
    } else {
      key = options.extra['idempotency_key'] as String? ??
          options.headers['Idempotency-Key'] as String?;

      if (key == null || key.isEmpty) {
        final isPurchasePath = _purchaseOrRecurringRegex.hasMatch(options.path);
        final hasExplicitIntent =
            (intentId != null && intentId.isNotEmpty) ||
                (explicitScope != null && explicitScope.isNotEmpty);
        key = IdempotencyScopeManager.getOrCreateKey(
          scope,
          reuseInFlight: !isPurchasePath || hasExplicitIntent,
        );
      } else {
        IdempotencyScopeManager.setKey(scope, key);
      }
    }

    options.extra['idempotency_key'] = key;
    options.extra['idempotency_scope'] = scope;
    options.extra['idempotency_session_epoch'] = IdempotencyScopeManager.sessionEpoch;
    if (intentId != null) options.extra['idempotency_intent_id'] = intentId;
    options.headers['Idempotency-Key'] = key;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final reqEpoch = response.requestOptions.extra['idempotency_session_epoch'] as int?;
    if (reqEpoch != null && reqEpoch != IdempotencyScopeManager.sessionEpoch) {
      handler.next(response);
      return;
    }

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
      final doneIntent =
          response.requestOptions.extra['idempotency_intent_id'] as String?;
      if (doneIntent != null) IdempotencyScopeManager.resolveIntent(doneIntent);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final reqEpoch = err.requestOptions.extra['idempotency_session_epoch'] as int?;
    if (reqEpoch != null && reqEpoch != IdempotencyScopeManager.sessionEpoch) {
      handler.next(err);
      return;
    }

    final status = err.response?.statusCode;
    final responseData = err.response?.data;
    final scope = err.requestOptions.extra['idempotency_scope'] as String? ??
        IdempotencyScopeManager.deriveScope(
          err.requestOptions.method,
          err.requestOptions.path,
          null,
          err.requestOptions.data,
        );
    final key = err.requestOptions.extra['idempotency_key'] as String? ??
        err.requestOptions.headers['Idempotency-Key'] as String?;

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

    final shouldPreserveScope = !isIdempotencyExpiredOrReused &&
        (isIdempotencyInProgress || (isUncertain && !isIdempotencyExpiredOrReused) || (hasRetryAfter && isIdempotencyInProgress));

    final errIntent =
        err.requestOptions.extra['idempotency_intent_id'] as String?;
    if (shouldPreserveScope) {
      IdempotencyScopeManager.markIntentRetryable(scope, key);
      if (errIntent != null) {
        IdempotencyScopeManager.markIntentUnresolved(errIntent);
      }
    } else {
      IdempotencyScopeManager.clearIntent(scope, key);
      if (errIntent != null) IdempotencyScopeManager.resolveIntent(errIntent);
    }

    handler.next(err);
  }
}

/// Carries the identity of ONE user-initiated business action (a tap on
/// "submit") down to [IdempotencyInterceptor] through the async call chain
/// (Dart [Zone]), so no Retrofit signature / generated code needs to change.
class IdempotencyIntent {
  IdempotencyIntent._();

  static const Symbol _zoneKey = #assabIdempotencyIntentId;

  static String newId() => IdempotencyScopeManager.generateUuidV4();

  static String? get current => Zone.current[_zoneKey] as String?;

  static Future<T> run<T>(String intentId, Future<T> Function() body) {
    return runZoned(body, zoneValues: {_zoneKey: intentId});
  }
}

/// Mixin for presentation-layer owners (cubits) of a financial submission.
mixin UserIntentOwner {
  String? _userIntentId;
  String? _userIntentFingerprint;
  int? _userIntentSessionEpoch;
  bool _userIntentInFlight = false;
  bool _unknownAcrossSessionBoundary = false;

  /// Returns null when blocked pending reconciliation.
  Future<T?> runUserIntent<T>(
    String fingerprint,
    Future<T> Function() operation,
  ) async {
    final existing = _userIntentId;
    final currentEpoch = IdempotencyScopeManager.sessionEpoch;
    if (existing != null && _userIntentSessionEpoch != currentEpoch) {
      if (_userIntentInFlight ||
          _unknownAcrossSessionBoundary ||
          IdempotencyScopeManager.isIntentUnresolved(existing)) {
        _unknownAcrossSessionBoundary = true;
        return null;
      }
      _userIntentId = null;
      _userIntentFingerprint = null;
      _userIntentSessionEpoch = null;
    }

    final activeId = _userIntentId;
    if (activeId != null &&
        _userIntentFingerprint != fingerprint &&
        IdempotencyScopeManager.isIntentUnresolved(activeId)) {
      return null;
    }
    if (activeId == null || _userIntentFingerprint != fingerprint) {
      _userIntentId = IdempotencyIntent.newId();
      _userIntentFingerprint = fingerprint;
      _userIntentSessionEpoch = currentEpoch;
      _unknownAcrossSessionBoundary = false;
    }
    final id = _userIntentId!;
    final attemptEpoch = currentEpoch;
    _userIntentInFlight = true;
    try {
      return await IdempotencyIntent.run<T>(id, operation);
    } finally {
      if (_userIntentId == id && _userIntentSessionEpoch == attemptEpoch) {
        _userIntentInFlight = false;
        if (attemptEpoch != IdempotencyScopeManager.sessionEpoch) {
          _unknownAcrossSessionBoundary = true;
        } else if (!IdempotencyScopeManager.isIntentUnresolved(id)) {
          _userIntentId = null;
          _userIntentFingerprint = null;
          _userIntentSessionEpoch = null;
          _unknownAcrossSessionBoundary = false;
        } else {
          _unknownAcrossSessionBoundary = true;
        }
      }
    }
  }

  /// True while the last submission's outcome is unknown.
  bool get hasUnresolvedUserIntent =>
      _userIntentId != null &&
      (IdempotencyScopeManager.isIntentUnresolved(_userIntentId!) ||
          (_unknownAcrossSessionBoundary &&
              _userIntentSessionEpoch != IdempotencyScopeManager.sessionEpoch));

  /// Call only after server state has been reconciled.
  void reconcileUserIntent() {
    final id = _userIntentId;
    if (id != null) IdempotencyScopeManager.resolveIntent(id);
    _userIntentId = null;
    _userIntentFingerprint = null;
    _userIntentSessionEpoch = null;
    _userIntentInFlight = false;
    _unknownAcrossSessionBoundary = false;
  }
}
