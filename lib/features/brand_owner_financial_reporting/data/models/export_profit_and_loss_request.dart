class ExportProfitAndLossRequest {
  final int year;
  final int month;
  final String? branchId;
  final String formatType;
  final String? email;

  const ExportProfitAndLossRequest({
    required this.year,
    required this.month,
    this.branchId,
    required this.formatType,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      if (branchId != null) 'branch_id': branchId,
      'format_type': formatType,
      if (email != null) 'email': email,
    };
  }
}
