import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _CaptureRequestHandler extends RequestInterceptorHandler {
  RequestOptions? options;
  @override
  void next(RequestOptions requestOptions) {
    options = requestOptions;
  }
}

class _CaptureErrorHandler extends ErrorInterceptorHandler {
  DioException? error;
  @override
  void next(DioException err) {
    error = err;
  }
}

void main() {
  group('F-04: Idempotency Intent Lifecycle and Error Handling', () {
    late IdempotencyInterceptor interceptor;

    setUp(() {
      IdempotencyScopeManager.resetAll();
      interceptor = IdempotencyInterceptor();
    });

    test('Clears idempotency key on IDEMPOTENCY_KEY_REUSED response', () {
      final attempt = RequestOptions(
        method: 'POST',
        path: 'cashier/shifts/101/end-with-handover',
        data: {'amount': '150.00'},
      );
      final handler1 = _CaptureRequestHandler();
      interceptor.onRequest(attempt, handler1);
      final key1 = handler1.options!.headers['Idempotency-Key'];
      expect(key1, isNotNull);

      // Server returns 409 IDEMPOTENCY_KEY_REUSED
      final err = DioException(
        requestOptions: attempt,
        response: Response(
          requestOptions: attempt,
          statusCode: 409,
          data: {'code': 'IDEMPOTENCY_KEY_REUSED', 'message': 'Idempotency key has already been used with different parameters'},
        ),
        type: DioExceptionType.badResponse,
      );
      final errHandler = _CaptureErrorHandler();
      interceptor.onError(err, errHandler);

      // Subsequent attempt must receive a fresh key
      final nextAttempt = RequestOptions(
        method: 'POST',
        path: 'cashier/shifts/101/end-with-handover',
        data: {'amount': '150.00'},
      );
      final handler2 = _CaptureRequestHandler();
      interceptor.onRequest(nextAttempt, handler2);
      final key2 = handler2.options!.headers['Idempotency-Key'];

      expect(key2, isNot(equals(key1)));
    });

    test('Clears idempotency key on RESPONSE_EXPIRED response', () {
      final attempt = RequestOptions(
        method: 'POST',
        path: 'shifts/101/handover/approve',
        data: {'confirmed_amount': '200.00'},
      );
      final handler1 = _CaptureRequestHandler();
      interceptor.onRequest(attempt, handler1);
      final key1 = handler1.options!.headers['Idempotency-Key'];

      // Server returns 409 RESPONSE_EXPIRED
      final err = DioException(
        requestOptions: attempt,
        response: Response(
          requestOptions: attempt,
          statusCode: 409,
          data: {'code': 'RESPONSE_EXPIRED', 'message': 'Cached idempotency response has expired'},
        ),
        type: DioExceptionType.badResponse,
      );
      interceptor.onError(err, _CaptureErrorHandler());

      final nextAttempt = RequestOptions(
        method: 'POST',
        path: 'shifts/101/handover/approve',
        data: {'confirmed_amount': '200.00'},
      );
      final handler2 = _CaptureRequestHandler();
      interceptor.onRequest(nextAttempt, handler2);
      final key2 = handler2.options!.headers['Idempotency-Key'];

      expect(key2, isNot(equals(key1)));
    });

    test('Clears idempotency key on SCOPE_CHANGED response', () {
      final attempt = RequestOptions(
        method: 'POST',
        path: 'shifts/101/handover/reject',
        data: {'reason': 'test'},
      );
      final handler1 = _CaptureRequestHandler();
      interceptor.onRequest(attempt, handler1);
      final key1 = handler1.options!.headers['Idempotency-Key'];

      final err = DioException(
        requestOptions: attempt,
        response: Response(
          requestOptions: attempt,
          statusCode: 409,
          data: {'code': 'SCOPE_CHANGED', 'message': 'Scope changed'},
        ),
        type: DioExceptionType.badResponse,
      );
      interceptor.onError(err, _CaptureErrorHandler());

      final nextAttempt = RequestOptions(
        method: 'POST',
        path: 'shifts/101/handover/reject',
        data: {'reason': 'test'},
      );
      final handler2 = _CaptureRequestHandler();
      interceptor.onRequest(nextAttempt, handler2);
      final key2 = handler2.options!.headers['Idempotency-Key'];

      expect(key2, isNot(equals(key1)));
    });

    test('force_new_intent triggers fresh key generation even with active key', () {
      final attempt = RequestOptions(
        method: 'POST',
        path: 'shifts/101/handover/approve',
        data: {'confirmed_amount': '100.00'},
      );
      final handler1 = _CaptureRequestHandler();
      interceptor.onRequest(attempt, handler1);
      final key1 = handler1.options!.headers['Idempotency-Key'];

      // Normal retry without error would reuse key if unchanged
      final retrySame = RequestOptions(
        method: 'POST',
        path: 'shifts/101/handover/approve',
        data: {'confirmed_amount': '100.00'},
      );
      final handler2 = _CaptureRequestHandler();
      interceptor.onRequest(retrySame, handler2);
      expect(handler2.options!.headers['Idempotency-Key'], equals(key1));

      // With force_new_intent, a fresh key is generated
      final forceNewAttempt = RequestOptions(
        method: 'POST',
        path: 'shifts/101/handover/approve',
        data: {'confirmed_amount': '100.00'},
        extra: {'force_new_intent': true},
      );
      final handler3 = _CaptureRequestHandler();
      interceptor.onRequest(forceNewAttempt, handler3);
      final key3 = handler3.options!.headers['Idempotency-Key'];

      expect(key3, isNot(equals(key1)));
    });
  });
}
