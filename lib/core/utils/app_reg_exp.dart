import '../enums/password_strength.dart';

class AppRegExp {
  const AppRegExp._();

  static bool emailValidator(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return false;
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
    );

    return emailRegex.hasMatch(trimmed);
  }

  /// Normalizes a Saudi phone number to canonical E.164 format: `+9665XXXXXXXX` (13 characters).
  ///
  /// Supported inputs:
  /// - `5XXXXXXXX` (9 digits)
  /// - `05XXXXXXXX` (10 digits)
  /// - `9665XXXXXXXX` (12 digits)
  /// - `009665XXXXXXXX` (14 digits)
  /// - `+9665XXXXXXXX` (13 chars)
  ///
  /// Spaces and dashes are stripped before normalization.
  /// Returns `null` if the input cannot be normalized to a valid Saudi mobile phone.
  static String? normalizeSaudiPhone(String phone) {
    var cleaned = phone.replaceAll(RegExp(r'[\s\-]'), '').trim();
    if (cleaned.isEmpty) return null;

    if (cleaned.startsWith('00966')) {
      cleaned = '+966${cleaned.substring(5)}';
    } else if (cleaned.startsWith('966')) {
      cleaned = '+966${cleaned.substring(3)}';
    } else if (cleaned.startsWith('0')) {
      cleaned = '+966${cleaned.substring(1)}';
    } else if (cleaned.startsWith('5')) {
      cleaned = '+966$cleaned';
    }

    final normalizedRegex = RegExp(r'^\+9665\d{8}$');
    if (normalizedRegex.hasMatch(cleaned)) {
      return cleaned;
    }

    return null;
  }

  /// Validates whether a phone input is a valid Saudi mobile phone in any of the accepted formats:
  /// `5XXXXXXXX`, `05XXXXXXXX`, `9665XXXXXXXX`, `009665XXXXXXXX`, or `+9665XXXXXXXX` (with optional spaces or dashes).
  static bool phoneValidator(String phone) {
    return normalizeSaudiPhone(phone) != null;
  }

  static bool passwordValidator(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>_\-+~=/]).{8,}$',
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
    final normalized = normalizeSaudiPhone(phone) ?? phone.replaceAll(RegExp(r'[\s-]'), '');

    if (normalized.length >= 13 && normalized.startsWith('+966')) {
      final mainPart = normalized.substring(4);
      final maskedPart =
          '*' * (mainPart.length - 4) + mainPart.substring(mainPart.length - 4);
      return '+966$maskedPart';
    }

    return normalized;
  }

  static PasswordStrength getPasswordStrength(String password) {
    final hasLower = RegExp(r'[a-z]');
    final hasUpper = RegExp(r'[A-Z]');
    final hasDigit = RegExp(r'\d');
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+~=/]');

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
