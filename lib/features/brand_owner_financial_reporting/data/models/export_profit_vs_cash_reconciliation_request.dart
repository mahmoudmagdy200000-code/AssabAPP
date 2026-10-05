class ExportProfitVsCashReconciliationRequest {
  final String? branchId;
  final String formatType;
  final String? email;

  const ExportProfitVsCashReconciliationRequest({
    this.branchId,
    required this.formatType,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      if (branchId != null) 'branch_id': branchId,
      'format_type': formatType,
      if (email != null) 'email': email,
    };
  }
}
