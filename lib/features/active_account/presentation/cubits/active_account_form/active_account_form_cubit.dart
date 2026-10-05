import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:assab/core/utils/app_reg_exp.dart';

import 'active_account_form_state.dart';

class ActiveAccountFormCubit extends SafeCubit<ActiveAccountFormState> {
  ActiveAccountFormCubit() : super(const ActiveAccountFormState());

  void updateEmail(String email) {
    final isValid = AppRegExp.emailValidator(email);
    emit(
      state.copyWith(
        email: email,
        emailError: email.isNotEmpty ? (isValid ? null : '') : null,
        isFormValid: _isFormValid(email: email, password: state.password),
      ),
    );
  }

  void updatePassword(String password) {
    final isValid = AppRegExp.passwordValidator(password);
    emit(
      state.copyWith(
        password: password,
        passwordError: password.isNotEmpty ? (isValid ? null : '') : null,
        isFormValid: _isFormValid(email: state.email, password: password),
      ),
    );
  }

  bool _isFormValid({required String email, required String password}) {
    return AppRegExp.emailValidator(email) &&
        AppRegExp.passwordValidator(password);
  }
}
