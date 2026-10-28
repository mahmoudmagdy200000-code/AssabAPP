import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FL-11: IdempotencyInterceptor & IdempotencyScopeManager tests', () {
    late IdempotencyInterceptor interceptor;

    setUp(() {
      IdempotencyScopeManager.resetAll();
      interceptor = IdempotencyInterceptor();
    });

    test('Attaches unique Idempotency-Key to financial dynamic route cashier/shifts/{id}/end', () {
      final options = RequestOptions(
        method: 'POST',
        path: 'cashier/shifts/101/end',
      );

      final handler = _CaptureRequestHandler();
      interceptor.onRequest(options, handler);

      expect(handler.options, isNotNull);
      final key = handler.options!.headers['Idempotency-Key'];
      expect(key, isNotNull);
      expect(key.toString().length, equals(36)); // UUID v4 length
      expect(handler.options!.extra['idempotency_key'], equals(key));
    });

    test('Reuses exact key across separate RequestOptions instances on user-initiated retry after uncertain timeout', () {
      // First attempt
      final attempt1 = RequestOptions(
        method: 'POST',
        path: 'cashier/shifts/101/end',
      );
      final handler1 = _CaptureRequestHandler();
      interceptor.onRequest(attempt1, handler1);
      final key1 = handler1.options!.headers['Idempotency-Key'];

      // Simulate connection timeout (uncertain outcome)
      final timeoutErr = DioException(
        requestOptions: attempt1,
        type: DioExceptionType.connectionTimeout,
        message: 'Connection timed out',
      );
      final errorHandler = _CaptureErrorHandler();
      interceptor.onError(timeoutErr, errorHandler);

      // User initiates retry: completely new RequestOptions instance created by Retrofit/Dio
      final attempt2 = RequestOptions(
        method: 'POST',
        path: 'cashier/shifts/101/end',
      );
      final handler2 = _CaptureRequestHandler();
      interceptor.onRequest(attempt2, handler2);
      final key2 = handler2.options!.headers['Idempotency-Key'];

      // Both attempts MUST share the identical Idempotency-Key
      expect(key2, equals(key1), reason: 'User retry after uncertain timeout must preserve idempotency key');
    });

    test('Genuinely new operation receives fresh key after previous operation succeeded', () {
      final attempt1 = RequestOptions(
        method: 'POST',
        path: 'cashier/shifts/101/end',
      );
      final handler1 = _CaptureRequestHandler();
      interceptor.onRequest(attempt1, handler1);
      final key1 = handler1.options!.headers['Idempotency-Key'];

      // Server responds 200 OK
      final response = Response(
        requestOptions: attempt1,
        statusCode: 200,
        data: {'success': true},
      );
      final responseHandler = _CaptureResponseHandler();
      interceptor.onResponse(response, responseHandler);

      // Later, user starts a new operation
      final newOperation = RequestOptions(
        method: 'POST',
        path: 'cashier/shifts/101/end',
      );
      final handler2 = _CaptureRequestHandler();
      interceptor.onRequest(newOperation, handler2);
      final key2 = handler2.options!.headers['Idempotency-Key'];

      expect(key2, isNot(equals(key1)), reason: 'New operation after success must receive a fresh key');
    });

    test('Scope is cleared on 422 client rejection so user can fix inputs and get fresh key', () {
      final attempt1 = RequestOptions(
        method: 'POST',
        path: 'cashier/shifts/101/end-with-handover',
      );
      final handler1 = _CaptureRequestHandler();
      interceptor.onRequest(attempt1, handler1);
      final key1 = handler1.options!.headers['Idempotency-Key'];

      // Server rejects with 422 Unprocessable Entity
      final err422 = DioException(
        requestOptions: attempt1,
        response: Response(requestOptions: attempt1, statusCode: 422),
        type: DioExceptionType.badResponse,
      );
      final errorHandler = _CaptureErrorHandler();
      interceptor.onError(err422, errorHandler);

      // User fixes input and resubmits
      final newSubmission = RequestOptions(
        method: 'POST',
        path: 'cashier/shifts/101/end-with-handover',
      );
      final handler2 = _CaptureRequestHandler();
      interceptor.onRequest(newSubmission, handler2);
      final key2 = handler2.options!.headers['Idempotency-Key'];

      expect(key2, isNot(equals(key1)), reason: 'New submission after client error gets fresh key');
    });

    test('Does not attach Idempotency-Key to GET requests', () {
      final options = RequestOptions(
        method: 'GET',
        path: 'cashier/shifts/101/available-recipients',
      );

      final handler = _CaptureRequestHandler();
      interceptor.onRequest(options, handler);

      expect(handler.options!.headers['Idempotency-Key'], isNull);
    });
  });
}

class _CaptureRequestHandler extends RequestInterceptorHandler {
  RequestOptions? options;

  @override
  void next(RequestOptions requestOptions) {
    options = requestOptions;
  }
}

class _CaptureResponseHandler extends ResponseInterceptorHandler {
  Response? response;

  @override
  void next(Response response) {
    this.response = response;
  }
}

class _CaptureErrorHandler extends ErrorInterceptorHandler {
  DioException? error;

  @override
  void next(DioException err) {
    error = err;
  }
}
