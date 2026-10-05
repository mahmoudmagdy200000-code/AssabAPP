import '../../domain/entities/brand_owner_report_entity.dart';
import '../../domain/strategies/brand_owner_reports_type_strategy.dart';

class BrandOwnerReportModel extends BrandOwnerReportEntity {
  const BrandOwnerReportModel({
    required super.id,
    required super.periodLabel,
    required super.statusLabel,
    required super.type,
  });

  factory BrandOwnerReportModel.fromJson(Map<String, dynamic> json) {
    return BrandOwnerReportModel(
      id: json['id']?.toString() ?? '',
      periodLabel: json['period_label'] ?? '',
      statusLabel: json['status_label'] ?? '',
      type: BrandOwnerReportsTypeStrategy.strategyForType(json['type'] ?? ''),
    );
  }
}
