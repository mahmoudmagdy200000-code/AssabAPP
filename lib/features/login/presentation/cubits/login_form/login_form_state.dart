class LoginFormState {
  final String identifier;
  final String password;
  final bool isIdentifierValid;
  final bool isPasswordValid;
  final bool saveLoginDetails;
  final String? identifierError;
  final String? passwordError;

  const LoginFormState({
    this.identifier = '',
    this.password = '',
    this.isIdentifierValid = false,
    this.isPasswordValid = false,
    this.saveLoginDetails = false,
    this.identifierError,
    this.passwordError,
  });

  bool get isFormValid => isIdentifierValid && isPasswordValid;

  LoginFormState copyWith({
    String? identifier,
    String? password,
    bool? isIdentifierValid,
    bool? isPasswordValid,
    bool? saveLoginDetails,
    String? Function()? identifierError,
    String? Function()? passwordError,
  }) {
    return LoginFormState(
      identifier: identifier ?? this.identifier,
      password: password ?? this.password,
      isIdentifierValid: isIdentifierValid ?? this.isIdentifierValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      saveLoginDetails: saveLoginDetails ?? this.saveLoginDetails,
      identifierError: identifierError != null ? identifierError() : this.identifierError,
      passwordError: passwordError != null ? passwordError() : this.passwordError,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is LoginFormState &&
      other.identifier == identifier &&
      other.password == password &&
      other.isIdentifierValid == isIdentifierValid &&
      other.isPasswordValid == isPasswordValid &&
      other.saveLoginDetails == saveLoginDetails &&
      other.identifierError == identifierError &&
      other.passwordError == passwordError;

  @override
  int get hashCode => Object.hash(
    identifier,
    password,
    isIdentifierValid,
    isPasswordValid,
    saveLoginDetails,
    identifierError,
    passwordError,
  );
}
