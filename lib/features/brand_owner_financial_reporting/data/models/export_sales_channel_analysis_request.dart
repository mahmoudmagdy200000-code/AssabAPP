class ExportSalesChannelAnalysisRequest {
  final int year;
  final int month;
  final int comparedYear;
  final int comparedMonth;
  final String branchId;
  final String formatType;
  final String? email;

  const ExportSalesChannelAnalysisRequest({
    required this.year,
    required this.month,
    required this.comparedYear,
    required this.comparedMonth,
    required this.branchId,
    required this.formatType,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'compared_year': comparedYear,
      'compared_month': comparedMonth,
      'branch_id': branchId,
      'format_type': formatType,
      if (email != null) 'email': email,
    };
  }
}
