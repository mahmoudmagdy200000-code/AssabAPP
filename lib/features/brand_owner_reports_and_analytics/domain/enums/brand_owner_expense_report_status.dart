enum BrandOwnerExpenseReportStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected');

  final String value;

  const BrandOwnerExpenseReportStatus(this.value);

  static BrandOwnerExpenseReportStatus? fromValue(String? value) {
    if (value == null || value.isEmpty) return null;

    return BrandOwnerExpenseReportStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => BrandOwnerExpenseReportStatus.pending,
    );
  }
}
