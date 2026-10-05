import 'package:assab/core/errors/api_error_model.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../helpers/safe_cubit.dart';
import '../../services/auth_service.dart';
import 'logout_state.dart';

@injectable
class LogoutCubit extends SafeCubit<LogoutState> {
  LogoutCubit() : super(const LogoutInitial());

  Future<void> logout() async {
    emit(const LogoutLoading());

    try {
      await AuthService.logout();
      emit(const LogoutSuccess());
    } catch (e) {
      emit(
        LogoutFailure(
          AuthFailure(
            error: DioErrorModel(message: e.toString()),
            icon: Icons.error,
            stackTrace: StackTrace.current,
            statusCode: 500,
          ),
        ),
      );
    }
  }
}
