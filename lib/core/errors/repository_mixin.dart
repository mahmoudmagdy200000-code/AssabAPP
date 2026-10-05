import 'package:dio/dio.dart';

import '../errors/api_cancelled_exception.dart';
import '../errors/api_error_handler.dart';
import '../utils/api_result.dart';
import '../utils/future_api_result.dart';

mixin RepositoryMixin {
  FutureApiResult<T> execute<T>(
    Future<T> Function() call, {
    void Function(dynamic error, StackTrace stackTrace)? onError,
  }) async {
    try {
      return ApiResult.success(await call());
    } catch (error, stackTrace) {
      if (_isCancellation(error)) return ApiResult.cancelled();

      onError?.call(error, stackTrace);

      try {
        return ApiResult.failure(ApiErrorHandler.handle(error, stackTrace));
      } on ApiCancelledException {
        return ApiResult.cancelled();
      }
    }
  }

  bool _isCancellation(Object error) =>
      (error is DioException && error.type == DioExceptionType.cancel) ||
      error is ApiCancelledException;
}
