import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:assab/core/utils/app_reg_exp.dart';

import 'login_form_state.dart';

class LoginFormCubit extends SafeCubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

  void updateIdentifier(String value) {
    final trimmed = value.trim();
    final isValid =
        AppRegExp.emailValidator(trimmed) || AppRegExp.phoneValidator(trimmed);
    final error = trimmed.isEmpty
        ? null
        : (isValid ? null : 'Invalid email or phone');

    emit(
      state.copyWith(
        identifier: trimmed,
        isIdentifierValid: isValid,
        identifierError: () => error,
      ),
    );
  }

  void updatePassword(String value) {
    // Login authenticates an existing backend account; do not block valid
    // server-side credentials with password-creation complexity rules.
    final isValid = value.isNotEmpty;
    final error = value.isEmpty ? null : null;

    emit(
      state.copyWith(
        password: value,
        isPasswordValid: isValid,
        passwordError: () => error,
      ),
    );
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
    final trimmed = identifier.trim();
    final isValid =
        AppRegExp.emailValidator(trimmed) || AppRegExp.phoneValidator(trimmed);
    emit(state.copyWith(identifier: trimmed, isIdentifierValid: isValid));
  }
}
