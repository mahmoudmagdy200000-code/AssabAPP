import 'dart:math';
import 'package:dio/dio.dart';

class IdempotencyInterceptor extends Interceptor {
  static final _financialPatterns = [
    'start-handover',
    'end-with-handover',
    'reassign-with-handover',
    'replace-recipient',
    'shifts/end',
    'handover-receipts',
  ];

  static String generateKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() == 'POST') {
      final isFinancial = _financialPatterns.any((p) => options.path.contains(p));
      if (isFinancial) {
        final key = options.extra['idempotency_key'] as String? ??
            options.headers['Idempotency-Key'] as String? ??
            generateKey();

        options.extra['idempotency_key'] = key;
        options.headers['Idempotency-Key'] = key;
      }
    }
    handler.next(options);
  }
}
