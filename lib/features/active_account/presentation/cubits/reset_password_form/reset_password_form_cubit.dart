import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:assab/core/utils/app_reg_exp.dart';

import 'reset_password_form_state.dart';

class ResetPasswordFormCubit extends SafeCubit<ResetPasswordFormState> {
  ResetPasswordFormCubit() : super(const ResetPasswordFormState());

  void updatePassword(String password) {
    final isValid = AppRegExp.passwordValidator(password);
    emit(
      state.copyWith(
        password: password,
        passwordError: password.isNotEmpty ? (isValid ? null : '') : null,
        isFormValid: _isFormValid(
          password: password,
          confirmPassword: state.confirmPassword,
        ),
      ),
    );
  }

  void updateConfirmPassword(String confirmPassword) {
    final isValid = AppRegExp.passwordValidator(confirmPassword);
    final isMatching = confirmPassword == state.password;

    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        confirmPasswordError: confirmPassword.isNotEmpty
            ? (isValid && isMatching ? null : '')
            : null,
        isFormValid: _isFormValid(
          password: state.password,
          confirmPassword: confirmPassword,
        ),
      ),
    );
  }

  bool _isFormValid({required String password, required String confirmPassword}) {
    return AppRegExp.passwordValidator(password) &&
        AppRegExp.passwordValidator(confirmPassword) &&
        password == confirmPassword;
  }
}
