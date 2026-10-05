import 'brand_owner_export_history_entity.dart';
import 'brand_owner_report_entity.dart';

class BrandOwnerReportsAndAnalyticsEntity {
  final List<BrandOwnerReportEntity> reports;
  final List<BrandOwnerExportHistoryEntity> exportHistory;

  const BrandOwnerReportsAndAnalyticsEntity({
    required this.reports,
    required this.exportHistory,
  });
}
