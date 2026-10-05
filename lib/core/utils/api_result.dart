import '../errors/api_failure.dart';

abstract class ApiResult<S> {
  const ApiResult();

  factory ApiResult.failure(ApiFailure failure) = _Failure<S>;
  factory ApiResult.success(S success) = _Success<S>;
  factory ApiResult.cancelled() = _Cancelled<S>;

  bool get isCancelled => this is _Cancelled<S>;

  T when<T>({
    required T Function(ApiFailure failure) failure,
    required T Function(S success) success,
  });
}

class _Failure<S> extends ApiResult<S> {
  final ApiFailure value;

  const _Failure(this.value);

  @override
  T when<T>({
    required Function(ApiFailure failure) failure,
    required Function(S success) success,
  }) {
    return failure(value);
  }
}

class _Success<S> extends ApiResult<S> {
  final S value;

  const _Success(this.value);

  @override
  T when<T>({
    required T Function(ApiFailure failure) failure,
    required T Function(S success) success,
  }) {
    return success(value);
  }
}

class _Cancelled<S> extends ApiResult<S> {
  const _Cancelled();

  @override
  T when<T>({
    required T Function(ApiFailure failure) failure,
    required T Function(S success) success,
  }) => throw StateError(
    '_Cancelled should never reach when(). '
    'SafeCubit.emit() must intercept it first.',
  );
}
