/// Utility for normalizing currency amounts in SAR, handling Eastern Arabic digits,
/// commas, decimal points, and enforcing standard 2-decimal-place serialization.
class CurrencyNormalizer {
  CurrencyNormalizer._();

  static const Map<String, String> _arabicToAsciiDigits = {
    // Arabic-Indic digits (U+0660 - U+0669)
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
    // Extended Arabic-Indic / Persian digits (U+06F0 - U+06F9)
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
  };

  /// Converts Arabic-Indic digits to ASCII standard digits, replaces Arabic
  /// decimal separator with standard '.', and strips thousands separators.
  static String sanitizeNumericString(String input) {
    var result = input.trim();
    // Replace Arabic and Persian digits
    _arabicToAsciiDigits.forEach((arabic, ascii) {
      result = result.replaceAll(arabic, ascii);
    });

    // Replace Arabic decimal separator (U+066B) or comma if used as decimal
    result = result.replaceAll('٫', '.');

    // Remove Arabic thousands separator (U+066C) and ASCII commas
    result = result.replaceAll('٬', '').replaceAll(',', '');

    // Remove spaces
    result = result.replaceAll(' ', '');

    return result;
  }

  /// Parses an amount string to double, returning null if invalid or negative.
  static double? parseSarAmount(String? input) {
    if (input == null) return null;
    final sanitized = sanitizeNumericString(input);
    if (sanitized.isEmpty) return null;

    final regex = RegExp(r'^\d+(\.\d+)?$');
    if (!regex.hasMatch(sanitized)) return null;

    final parsed = double.tryParse(sanitized);
    if (parsed == null || parsed < 0 || parsed.isNaN || parsed.isInfinite) {
      return null;
    }
    return parsed;
  }

  /// Normalizes an input string to an exact 2-decimal-place SAR string (e.g. "150.00").
  /// Returns null if the input is not a valid non-negative number.
  static String? normalizeSarInput(String? input) {
    final parsed = parseSarAmount(input);
    if (parsed == null) return null;
    return parsed.toStringAsFixed(2);
  }

  /// Formats a numeric amount to standard 2-decimal-place SAR representation.
  static String formatSar(num amount) {
    return amount.toDouble().toStringAsFixed(2);
  }

  /// Checks if two amounts match at halala precision (rounding to nearest halala).
  static bool areAmountsEqual(double a, double b) {
    final aMinor = (a * 100).round();
    final bMinor = (b * 100).round();
    return aMinor == bMinor;
  }
}
