class BranchManagerExportPriceComparisonResponse {
  final String url;

  const BranchManagerExportPriceComparisonResponse({required this.url});

  factory BranchManagerExportPriceComparisonResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return BranchManagerExportPriceComparisonResponse(url: json['data']['url']);
  }
}
