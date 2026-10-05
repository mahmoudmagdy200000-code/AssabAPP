import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:assab/core/utils/app_reg_exp.dart';

import 'login_form_state.dart';

class LoginFormCubit extends SafeCubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

  void updateIdentifier(String value) {
    final isValid = AppRegExp.emailValidator(value) || AppRegExp.phoneValidator(value);
    final error = value.isEmpty
        ? null
        : (isValid ? null : 'Invalid email or phone');

    emit(state.copyWith(
      identifier: value,
      isIdentifierValid: isValid,
      identifierError: () => error,
    ));
  }

  void updatePassword(String value) {
    final isValid = AppRegExp.passwordValidator(value);
    final error = value.isEmpty
        ? null
        : (isValid ? null : 'Password not valid');

    emit(state.copyWith(
      password: value,
      isPasswordValid: isValid,
      passwordError: () => error,
    ));
  }

  void toggleSaveLoginDetails(bool value) {
    emit(state.copyWith(saveLoginDetails: value));
  }

  void setIdentifierError(String? error) {
    emit(state.copyWith(identifierError: () => error));
  }

  void setPasswordError(String? error) {
    emit(state.copyWith(passwordError: () => error));
  }

  void initWithIdentifier(String identifier) {
    final isValid = AppRegExp.emailValidator(identifier) || AppRegExp.phoneValidator(identifier);
    emit(state.copyWith(
      identifier: identifier,
      isIdentifierValid: isValid,
    ));
  }
}
