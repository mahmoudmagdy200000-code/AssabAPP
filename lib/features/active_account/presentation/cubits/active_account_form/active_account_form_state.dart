class ActiveAccountFormState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isFormValid;

  const ActiveAccountFormState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isFormValid = false,
  });

  ActiveAccountFormState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isFormValid,
  }) {
    return ActiveAccountFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ActiveAccountFormState &&
      other.email == email &&
      other.password == password &&
      other.emailError == emailError &&
      other.passwordError == passwordError &&
      other.isFormValid == isFormValid;

  @override
  int get hashCode => Object.hash(
    email,
    password,
    emailError,
    passwordError,
    isFormValid,
  );
}
