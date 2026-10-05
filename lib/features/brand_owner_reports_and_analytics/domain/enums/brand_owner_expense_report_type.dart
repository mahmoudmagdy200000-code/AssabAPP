enum BrandOwnerExpenseReportType {
  quickCash('quick_cash'),
  invoice('invoice');

  final String value;

  const BrandOwnerExpenseReportType(this.value);

  static BrandOwnerExpenseReportType? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;

    return BrandOwnerExpenseReportType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => BrandOwnerExpenseReportType.quickCash,
    );
  }
}
