class ExportAsPdfResponse {
  final String fileUrl;

  ExportAsPdfResponse({required this.fileUrl});

  factory ExportAsPdfResponse.fromJson(Map<String, dynamic> json) {
    return ExportAsPdfResponse(fileUrl: json['data']['file_url'] as String);
  }
}
