import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:assab/core/utils/app_reg_exp.dart';

import 'active_account_form_state.dart';

class ActiveAccountFormCubit extends SafeCubit<ActiveAccountFormState> {
  ActiveAccountFormCubit() : super(const ActiveAccountFormState());

  void updateEmail(String email) {
    final trimmed = email.trim();
    final isValid = AppRegExp.emailValidator(trimmed);
    emit(
      state.copyWith(
        email: trimmed,
        emailError: trimmed.isNotEmpty ? (isValid ? null : '') : null,
        isFormValid: _isFormValid(email: trimmed, password: state.password),
      ),
    );
  }

  void updatePassword(String password) {
    // Default issued passwords may be arbitrary tokens/passphrases.
    emit(
      state.copyWith(
        password: password,
        passwordError: null,
        isFormValid: _isFormValid(email: state.email, password: password),
      ),
    );
  }

  bool _isFormValid({required String email, required String password}) {
    return AppRegExp.emailValidator(email) && password.isNotEmpty;
  }
}
