import 'package:assab/core/network/cancel_token_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FL-07: CancelTokenInterceptor propagates cancel error to handler instead of hanging', () {
    final interceptor = CancelTokenInterceptor();
    final options = RequestOptions(path: '/api/v1/test');
    final cancelException = DioException(
      requestOptions: options,
      type: DioExceptionType.cancel,
      message: 'Request was cancelled',
    );

    var calledNext = false;

    // Attach custom callback to verify next is called
    interceptor.onError(
      cancelException,
      _MockErrorHandler((err) {
        calledNext = true;
        expect(err.type, equals(DioExceptionType.cancel));
      }),
    );

    expect(calledNext, isTrue, reason: 'CancelTokenInterceptor must forward cancel error so futures resolve');
  });
}

class _MockErrorHandler extends ErrorInterceptorHandler {
  final void Function(DioException err) onNext;

  _MockErrorHandler(this.onNext);

  @override
  void next(DioException err) {
    onNext(err);
  }
}
