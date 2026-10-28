import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FL-11: IdempotencyInterceptor tests', () {
    final interceptor = IdempotencyInterceptor();

    test('Attaches unique Idempotency-Key to financial POST requests', () {
      final options = RequestOptions(
        method: 'POST',
        path: 'cashier/shifts/shift-1/start-handover',
      );

      final handler = _CaptureHandler();
      interceptor.onRequest(options, handler);

      expect(handler.options, isNotNull);
      final key = handler.options!.headers['Idempotency-Key'];
      expect(key, isNotNull);
      expect(key.toString().length, equals(36)); // UUID v4 format
      expect(handler.options!.extra['idempotency_key'], equals(key));
    });

    test('Reuses existing idempotency key on retry', () {
      const fixedKey = '11111111-2222-3333-4444-555555555555';
      final options = RequestOptions(
        method: 'POST',
        path: 'cashier/shifts/shift-1/end-with-handover',
        extra: {'idempotency_key': fixedKey},
      );

      final handler = _CaptureHandler();
      interceptor.onRequest(options, handler);

      expect(handler.options!.headers['Idempotency-Key'], equals(fixedKey));
    });

    test('Does not attach Idempotency-Key to GET requests', () {
      final options = RequestOptions(
        method: 'GET',
        path: 'cashier/shifts/shift-1/available-recipients',
      );

      final handler = _CaptureHandler();
      interceptor.onRequest(options, handler);

      expect(handler.options!.headers['Idempotency-Key'], isNull);
    });
  });
}

class _CaptureHandler extends RequestInterceptorHandler {
  RequestOptions? options;

  @override
  void next(RequestOptions requestOptions) {
    options = requestOptions;
  }
}
