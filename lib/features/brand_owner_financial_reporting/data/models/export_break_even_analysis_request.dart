class ExportBreakEvenAnalysisRequest {
  final int year;
  final int month;
  final String branchId;
  final String formatType;

  const ExportBreakEvenAnalysisRequest({
    required this.year,
    required this.month,
    required this.branchId,
    required this.formatType,
  });

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'branch_id': branchId,
      'format_type': formatType,
    };
  }
}
