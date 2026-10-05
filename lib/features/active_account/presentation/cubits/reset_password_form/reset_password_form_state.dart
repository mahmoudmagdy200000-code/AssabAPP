class ResetPasswordFormState {
  final String password;
  final String confirmPassword;
  final String? passwordError;
  final String? confirmPasswordError;
  final bool isFormValid;

  const ResetPasswordFormState({
    this.password = '',
    this.confirmPassword = '',
    this.passwordError,
    this.confirmPasswordError,
    this.isFormValid = false,
  });

  ResetPasswordFormState copyWith({
    String? password,
    String? confirmPassword,
    String? passwordError,
    String? confirmPasswordError,
    bool? isFormValid,
  }) {
    return ResetPasswordFormState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ResetPasswordFormState &&
      other.password == password &&
      other.confirmPassword == confirmPassword &&
      other.passwordError == passwordError &&
      other.confirmPasswordError == confirmPasswordError &&
      other.isFormValid == isFormValid;

  @override
  int get hashCode => Object.hash(
    password,
    confirmPassword,
    passwordError,
    confirmPasswordError,
    isFormValid,
  );
}
