import 'dart:async';

import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Stage 0 T0.4: Purchase & RecurringOrder IdempotencyInterceptor', () {
    late IdempotencyInterceptor interceptor;

    setUp(() {
      IdempotencyScopeManager.resetAll();
      interceptor = IdempotencyInterceptor();
    });

    test('Attaches RFC4122 v4 Idempotency-Key on Purchase and RecurringOrder write routes', () {
      final routes = <MapEntry<String, String>>[
        const MapEntry('POST', 'v1/purchase/orders'),
        const MapEntry('PUT', 'v1/purchase/orders/123/items'),
        const MapEntry('POST', 'v1/purchase/orders/123/submit'),
        const MapEntry('DELETE', 'v1/purchase/orders/123/draft'),
        const MapEntry('POST', 'v1/purchase/orders/compare-prices/save'),
        const MapEntry('POST', 'v1/purchase/pending/123/approve-transfer'),
        const MapEntry('POST', 'v1/purchase/receiving/without-order'),
        const MapEntry('POST', 'v1/purchase/receiving/orders/123/start'),
        const MapEntry('POST', 'v1/purchase/receiving/orders/123/receive-internal-transfer'),
        const MapEntry('POST', 'v1/purchase/receiving/456/complete'),
        const MapEntry('POST', 'v1/purchase/receiving/variances/789/supplier-response'),
        const MapEntry('POST', 'v1/purchase/returns'),
        const MapEntry('PUT', 'v1/purchase/returns/123'),
        const MapEntry('POST', 'v1/purchase/returns/123/submit'),
        const MapEntry('POST', 'v1/recurring-orders'),
        const MapEntry('POST', 'v1/recurring-orders/123/pause'),
        const MapEntry('PUT', 'v1/recurring-orders/123'),
        const MapEntry('DELETE', 'v1/recurring-orders/123'),
      ];

      for (final entry in routes) {
        final options = RequestOptions(method: entry.key, path: entry.value);
        final handler = _CaptureRequestHandler();
        interceptor.onRequest(options, handler);

        final key = handler.options?.headers['Idempotency-Key'];
        expect(key, isNotNull, reason: '${entry.key} ${entry.value} must carry Idempotency-Key');
        expect(key.toString().length, equals(36));
      }
    });

    test('Does not attach Idempotency-Key to read-only GET routes or compare-prices query', () {
      final skipped = <MapEntry<String, String>>[
        const MapEntry('GET', 'v1/purchase/orders'),
        const MapEntry('GET', 'v1/purchase/receiving/in-progress'),
        const MapEntry('POST', 'v1/purchase/orders/compare-prices'),
      ];

      for (final entry in skipped) {
        final options = RequestOptions(method: entry.key, path: entry.value);
        final handler = _CaptureRequestHandler();
        interceptor.onRequest(options, handler);
        expect(handler.options?.headers['Idempotency-Key'], isNull);
      }
    });

    test('Preserves same key on uncertain timeout and mints fresh key after completion or payload change', () {
      final attempt1 = RequestOptions(
        method: 'POST',
        path: 'v1/purchase/orders',
        data: {'items': [{'id': 'i1', 'qty': 2}]},
      );
      final h1 = _CaptureRequestHandler();
      interceptor.onRequest(attempt1, h1);
      final key1 = h1.options!.headers['Idempotency-Key'];

      interceptor.onError(
        DioException(requestOptions: attempt1, type: DioExceptionType.connectionTimeout),
        _CaptureErrorHandler(),
      );

      final retry = RequestOptions(
        method: 'POST',
        path: 'v1/purchase/orders',
        data: {'items': [{'id': 'i1', 'qty': 2}]},
      );
      final hRetry = _CaptureRequestHandler();
      interceptor.onRequest(retry, hRetry);
      expect(hRetry.options!.headers['Idempotency-Key'], equals(key1));

      interceptor.onResponse(
        Response(requestOptions: retry, statusCode: 201, data: {'success': true}),
        _CaptureResponseHandler(),
      );

      final independentOp = RequestOptions(
        method: 'POST',
        path: 'v1/purchase/orders',
        data: {'items': [{'id': 'i1', 'qty': 2}]},
      );
      final hNew = _CaptureRequestHandler();
      interceptor.onRequest(independentOp, hNew);
      expect(hNew.options!.headers['Idempotency-Key'], isNot(equals(key1)));
    });

    test('independent Purchase requests with identical payloads get distinct keys without IdempotencyIntent', () {
      final opts1 = RequestOptions(
        path: 'purchase/receiving/orders/order-1/receive-internal-transfer',
        method: 'POST',
        data: {'qty': 5},
      );
      interceptor.onRequest(opts1, _CaptureRequestHandler());

      final opts2 = RequestOptions(
        path: 'purchase/receiving/orders/order-1/receive-internal-transfer',
        method: 'POST',
        data: {'qty': 5},
      );
      interceptor.onRequest(opts2, _CaptureRequestHandler());

      expect(
        opts1.headers['Idempotency-Key'],
        isNot(equals(opts2.headers['Idempotency-Key'])),
      );
    });

    test('account/session isolation separates scopes via Authorization header and bindSession', () {
      final reqA = RequestOptions(
        path: 'purchase/orders',
        method: 'POST',
        headers: {'Authorization': 'Bearer token-account-A'},
        data: {'qty': 5},
      );
      interceptor.onRequest(reqA, _CaptureRequestHandler());

      final reqB = RequestOptions(
        path: 'purchase/orders',
        method: 'POST',
        headers: {'Authorization': 'Bearer token-account-B'},
        data: {'qty': 5},
      );
      interceptor.onRequest(reqB, _CaptureRequestHandler());
      expect(reqA.headers['Idempotency-Key'], isNot(equals(reqB.headers['Idempotency-Key'])));

      IdempotencyScopeManager.startSession(
        principalType: 'branch_manager',
        principalId: 'session-1',
      );
      final s1 = RequestOptions(path: 'shifts/1/end', method: 'POST', data: {'a': 1});
      interceptor.onRequest(s1, _CaptureRequestHandler());

      IdempotencyScopeManager.startSession(
        principalType: 'branch_manager',
        principalId: 'session-2',
      );
      final s2 = RequestOptions(path: 'shifts/1/end', method: 'POST', data: {'a': 1});
      interceptor.onRequest(s2, _CaptureRequestHandler());
      expect(s1.headers['Idempotency-Key'], isNot(equals(s2.headers['Idempotency-Key'])));
    });

    test('FormData file metadata and query parameters are included in scope fingerprint', () async {
      final form1 = FormData.fromMap({
        'note': 'same',
        'file': MultipartFile.fromBytes([1, 2, 3], filename: 'a.jpg'),
      });
      final form2 = FormData.fromMap({
        'note': 'same',
        'file': MultipartFile.fromBytes([1, 2, 3, 4], filename: 'b.jpg'),
      });
      final r1 = RequestOptions(path: 'purchase/receiving/1/invoice', method: 'POST', data: form1);
      final r2 = RequestOptions(path: 'purchase/receiving/1/invoice', method: 'POST', data: form2);
      final h1 = _CompleterRequestHandler();
      final h2 = _CompleterRequestHandler();
      interceptor.onRequest(r1, h1);
      interceptor.onRequest(r2, h2);
      await Future.wait([h1.done, h2.done]);
      expect(r1.extra['idempotency_scope'], isNot(equals(r2.extra['idempotency_scope'])));

      final q1 = RequestOptions(path: 'purchase/orders', method: 'POST', queryParameters: {'b': 2});
      final q2 = RequestOptions(path: 'purchase/orders', method: 'POST', queryParameters: {'b': 3});
      interceptor.onRequest(q1, _CaptureRequestHandler());
      interceptor.onRequest(q2, _CaptureRequestHandler());
      expect(q1.extra['idempotency_scope'], isNot(equals(q2.extra['idempotency_scope'])));
    });
  });
}

class _CompleterRequestHandler extends RequestInterceptorHandler {
  final Completer<RequestOptions> _c = Completer<RequestOptions>();
  Future<RequestOptions> get done => _c.future;
  @override
  void next(RequestOptions requestOptions) {
    if (!_c.isCompleted) _c.complete(requestOptions);
  }
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
