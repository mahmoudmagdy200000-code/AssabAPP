class FixedAssetPreviewGenerateReportResponse {
  final String reportId;
  final String fileName;
  final String downloadUrl;
  final String generatedAt;

  const FixedAssetPreviewGenerateReportResponse({
    required this.reportId,
    required this.fileName,
    required this.downloadUrl,
    required this.generatedAt,
  });

  factory FixedAssetPreviewGenerateReportResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data']['data'] as Map<String, dynamic>? ?? json;

    return FixedAssetPreviewGenerateReportResponse(
      reportId: data['reportId'] ?? '',
      fileName: data['fileName'] ?? '',
      downloadUrl: data['downloadUrl'] ?? '',
      generatedAt: data['generatedAt'] ?? '',
    );
  }
}
