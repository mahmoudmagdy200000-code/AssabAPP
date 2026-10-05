class BranchManagerResetMyPasswordRequestModel {
  final String oldPassword;
  final String password;
  final String passwordConfirmation;

  const BranchManagerResetMyPasswordRequestModel({
    required this.oldPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}