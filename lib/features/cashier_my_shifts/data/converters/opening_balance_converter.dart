int? openingBalanceFromJson(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;

  if (value is num) return value.toInt();

  if (value is String) {
    return int.tryParse(value);
  }

  return null;
}
