extension StringExtensions on String {
  double toDoubleOrZero() => double.tryParse(this) ?? 0.0;

  int toIntOrZero() => int.tryParse(this) ?? 0;
}
