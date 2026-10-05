class ExportSalesChannelLevel2Request {
  final int year;
  final int month;
  final int comparedYear;
  final int comparedMonth;
  final String? branchId;
  final String formatType;

  const ExportSalesChannelLevel2Request({
    required this.year,
    required this.month,
    required this.comparedYear,
    required this.comparedMonth,
    this.branchId,
    required this.formatType,
  });

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'compared_year': comparedYear,
      'compared_month': comparedMonth,
      if (branchId != null) 'branch_id': branchId,
      'format_type': formatType,
    };
  }
}
