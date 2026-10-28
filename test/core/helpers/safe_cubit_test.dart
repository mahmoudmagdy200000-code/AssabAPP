import 'package:assab/core/errors/api_error_model.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class _TestState {
  const _TestState();
}

class _InitialState extends _TestState {
  const _InitialState();
}

class _LoadingState extends _TestState {
  const _LoadingState();
}

class _SuccessState extends _TestState {
  final String data;
  const _SuccessState(this.data);
}

class _FailureState extends _TestState {
  final String error;
  const _FailureState(this.error);
}

class _ConcreteCubit extends SafeCubit<_TestState> {
  _ConcreteCubit() : super(const _InitialState());

  void executeWithCancelSupport(ApiResult<String> result, {void Function()? onCancel, bool resetOnCancel = true}) {
    emit(const _LoadingState());
    handle(
      result,
      success: (data) => emit(_SuccessState(data)),
      failure: (f) => emit(_FailureState(f.error.message ?? 'Error')),
      onCancel: onCancel,
      resetOnCancel: resetOnCancel,
    );
  }
}

void main() {
  group('FL-07: SafeCubit Cancellation & Loading State Unblocking Tests', () {
    late _ConcreteCubit cubit;

    setUp(() {
      cubit = _ConcreteCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('Success unblocks loading and emits SuccessState', () {
      cubit.executeWithCancelSupport(ApiResult.success('OK'));
      expect(cubit.state, isA<_SuccessState>());
    });

    test('Failure unblocks loading and emits FailureState', () {
      final failure = NetworkFailure(
        error: DioErrorModel(message: 'Network Error'),
        icon: CupertinoIcons.clear,
        statusCode: 500,
        stackTrace: StackTrace.empty,
      );
      cubit.executeWithCancelSupport(ApiResult.failure(failure));
      expect(cubit.state, isA<_FailureState>());
    });

    test('Cancellation with default resetOnCancel=true automatically resets to InitialState (unblocks loading)', () {
      // Prior to the fix, this would remain stuck in _LoadingState!
      cubit.executeWithCancelSupport(ApiResult.cancelled());

      expect(cubit.state, isA<_InitialState>(), reason: 'Cancellation must unblock loading state and return to initial state');
    });

    test('Cancellation with custom onCancel callback invokes callback', () {
      var customCallbackInvoked = false;

      cubit.executeWithCancelSupport(
        ApiResult.cancelled(),
        onCancel: () {
          customCallbackInvoked = true;
          cubit.emit(const _FailureState('Cancelled by user'));
        },
      );

      expect(customCallbackInvoked, isTrue);
      expect(cubit.state, isA<_FailureState>());
    });

    test('Cancellation with resetOnCancel=false does not reset state', () {
      cubit.executeWithCancelSupport(
        ApiResult.cancelled(),
        resetOnCancel: false,
      );

      // Remains in LoadingState because reset was explicitly disabled
      expect(cubit.state, isA<_LoadingState>());
    });
  });
}
