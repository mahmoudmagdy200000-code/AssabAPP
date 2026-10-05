class JsonValueParser {
  static double? toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? toInt(dynamic value) {
    if (value == null) return null;

    if (value is num) return value.toInt();

    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed?.toInt();
    }

    return null;
  }
}
