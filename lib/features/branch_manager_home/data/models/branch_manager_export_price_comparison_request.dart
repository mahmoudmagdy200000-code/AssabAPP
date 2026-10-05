class BranchManagerExportPriceComparisonRequest {
  final String formatType;

  const BranchManagerExportPriceComparisonRequest({required this.formatType});

  Map<String, dynamic> toJson() {
    return {'format_type': formatType};
  }
}
