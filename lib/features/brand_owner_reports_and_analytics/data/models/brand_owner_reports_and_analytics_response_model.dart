import '../../domain/entities/brand_owner_reports_and_analytics_entity.dart';
import 'brand_owner_export_history_model.dart';
import 'brand_owner_report_model.dart';

class BrandOwnerReportsAndAnalyticsResponseModel {
  final List<BrandOwnerReportModel> reports;
  final List<BrandOwnerExportHistoryModel> exportHistory;

  const BrandOwnerReportsAndAnalyticsResponseModel({
    required this.reports,
    required this.exportHistory,
  });

  factory BrandOwnerReportsAndAnalyticsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final reportsJson = data['reports'] as List<dynamic>? ?? [];
    final exportHistoryJson = data['export_history'] as List<dynamic>? ?? [];

    return BrandOwnerReportsAndAnalyticsResponseModel(
      reports: reportsJson
          .map(
            (item) =>
                BrandOwnerReportModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      exportHistory: exportHistoryJson
          .map(
            (item) => BrandOwnerExportHistoryModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  BrandOwnerReportsAndAnalyticsEntity toEntity() {
    return BrandOwnerReportsAndAnalyticsEntity(
      reports: reports,
      exportHistory: exportHistory,
    );
  }
}
