import 'dart:math';
import 'package:assab/core/services/user_type_service.dart';
import 'package:dio/dio.dart';

/// Manages idempotency keys across logical financial operations and user-initiated retries.
class IdempotencyScopeManager {
  static final Map<String, String> _activeKeys = {};

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

  /// Get the active key for a logical scope, or generate a new one if none exists.
  static String getOrCreateKey(String scope) {
    return _activeKeys.putIfAbsent(scope, () => generateUuidV4());
  }

  /// Set or override key for an explicit scope
  static void setKey(String scope, String key) {
    _activeKeys[scope] = key;
  }

  /// Clear the key once an operation is confirmed successful, or when reset by user.
  static void clearScope(String scope) {
    _activeKeys.remove(scope);
  }

  /// Check if a scope has an active key
  static bool hasActiveKey(String scope) => _activeKeys.containsKey(scope);

  /// Reset all stored keys
  static void resetAll() {
    _activeKeys.clear();
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

        String? key = options.extra['idempotency_key'] as String? ??
            options.headers['Idempotency-Key'] as String?;

        if (key == null || key.isEmpty) {
          key = IdempotencyScopeManager.getOrCreateKey(scope);
        } else {
          IdempotencyScopeManager.setKey(scope, key);
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
    final scope = response.requestOptions.extra['idempotency_scope'] as String?;
    if (scope != null &&
        response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      IdempotencyScopeManager.clearScope(scope);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final isUncertain = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        status == 504 ||
        status == 502;

    final responseData = err.response?.data;
    final isIdempotencyInProgress = status == 409 &&
        (responseData is Map &&
            (responseData['code'] == 'IDEMPOTENCY_IN_PROGRESS' ||
                responseData['message']?.toString().contains('in progress') == true));

    final hasRetryAfter = err.response?.headers.value('retry-after') != null;

    final shouldPreserveScope =
        isUncertain || isIdempotencyInProgress || hasRetryAfter || status == 409;

    // Only clear on deterministic 4xx client errors where the server processed and rejected
    if (!shouldPreserveScope && status != null && status >= 400 && status < 500) {
      final scope = err.requestOptions.extra['idempotency_scope'] as String?;
      if (scope != null) {
        IdempotencyScopeManager.clearScope(scope);
      }
    }

    handler.next(err);
  }
}