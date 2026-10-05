import '../enums/password_strength.dart';

class AppRegExp {
  const AppRegExp._();

  static bool emailValidator(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    return emailRegex.hasMatch(email);
  }

  static bool phoneValidator(String phone) {
    final phoneRegex = RegExp(r'^\d{9}$');
    return phoneRegex.hasMatch(phone);
  }

  static bool passwordValidator(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  static RegExp get maskEmailRegExp => RegExp(r'^(.{4})([^@]*)(@.*)$');

  static String maskEmail(String email) {
    return email.replaceAllMapped(
      maskEmailRegExp,
      (m) => '${m[1]}${'*' * m[2]!.length}${m[3]}',
    );
  }

  static String maskSaudiPhone(String phone) {
    final normalized = phone.replaceAll(RegExp(r'[\s-]'), '');

    final mainPart = normalized.substring(4);

    final maskedPart =
        '*' * (mainPart.length - 4) + mainPart.substring(mainPart.length - 4);

    return '+966$maskedPart';
  }

  static PasswordStrength getPasswordStrength(String password) {
    final hasLower = RegExp(r'[a-z]');
    final hasUpper = RegExp(r'[A-Z]');
    final hasDigit = RegExp(r'\d');
    final hasSpecial = RegExp(r'[!@#%^&*(),.?":{}|<>_\-]');

    int patternsMatched = 0;
    if (hasLower.hasMatch(password)) patternsMatched++;
    if (hasUpper.hasMatch(password)) patternsMatched++;
    if (hasDigit.hasMatch(password)) patternsMatched++;
    if (hasSpecial.hasMatch(password)) patternsMatched++;

    if (password.length < 6 || patternsMatched < 2) {
      return PasswordStrength.weak;
    }

    if (password.length >= 6 && password.length < 8) {
      return PasswordStrength.medium;
    }

    if (password.length >= 8 &&
        hasLower.hasMatch(password) &&
        hasUpper.hasMatch(password) &&
        hasDigit.hasMatch(password) &&
        hasSpecial.hasMatch(password)) {
      return PasswordStrength.strong;
    }

    return PasswordStrength.medium;
  }
}
