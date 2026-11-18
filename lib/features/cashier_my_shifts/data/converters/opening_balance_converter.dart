double? openingBalanceFromJson(dynamic value) {
  if (value == null) return null;

  if (value is num) return value.toDouble();

  if (value is String) {
    return double.tryParse(value.trim());
  }

  return null;
}
