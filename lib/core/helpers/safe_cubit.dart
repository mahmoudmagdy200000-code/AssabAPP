import 'package:flutter_bloc/flutter_bloc.dart';

import '../errors/api_failure.dart';
import '../utils/api_result.dart';
import '../utils/app_logger.dart';

abstract class SafeCubit<State> extends Cubit<State> {
  final State _initialState;

  SafeCubit(super.initialState) : _initialState = initialState;

  void handle<T>(
    ApiResult<T> result, {
    required void Function(T data) success,
    required void Function(ApiFailure failure) failure,
    void Function()? onCancel,
    bool resetOnCancel = true,
  }) {
    if (isClosed) return;

    if (result.isCancelled) {
      if (onCancel != null) {
        onCancel();
      } else if (resetOnCancel) {
        emit(_initialState);
      }
      return;
    }

    result.when(success: success, failure: failure);
  }

  @override
  void emit(State state) {
    if (!isClosed) {
      super.emit(state);
    } else {
      AppLogger.log('Emit ignored — cubit is closed.');
    }
  }
}
