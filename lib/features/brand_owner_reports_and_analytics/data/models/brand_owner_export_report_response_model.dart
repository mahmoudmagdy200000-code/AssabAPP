class BrandOwnerExportReportResponseModel {
  final String fileUrl;

  const BrandOwnerExportReportResponseModel({required this.fileUrl});

  factory BrandOwnerExportReportResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerExportReportResponseModel(
      fileUrl: json['data']['file_url'] as String,
    );
  }

  String toEntity() => fileUrl;
}
