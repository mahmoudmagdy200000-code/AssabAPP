import '../strategies/brand_owner_reports_type_strategy.dart';

class BrandOwnerReportEntity {
  final String id;
  final String periodLabel;
  final String statusLabel;
  final BrandOwnerReportsTypeStrategy type;

  const BrandOwnerReportEntity({
    required this.id,
    required this.periodLabel,
    required this.statusLabel,
    required this.type,
  });
}
