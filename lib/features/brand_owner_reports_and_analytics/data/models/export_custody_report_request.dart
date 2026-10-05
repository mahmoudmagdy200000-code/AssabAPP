class ExportCustodyReportRequest {
  final int year;
  final int monthNumber;
  final String formatType;

  const ExportCustodyReportRequest({
    required this.year,
    required this.monthNumber,
    required this.formatType,
  });

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month_number': monthNumber,
      'format_type': formatType,
    };
  }
}
