import '../../domain/enums/brand_owner_smart_compare_type_enum.dart';
import '../models/export_smart_comparison_request.dart';
import '../models/smart_comparison_model.dart';

abstract class BrandOwnerSmartComparisonDataSource {
  Future<SmartComparisonModel> getSmartComparison({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    String? branchId,
    String? comparedBranchId,
  });

  Future<String> exportSmartComparison({
    required ExportSmartComparisonRequest request,
  });

  Future<void> emailSmartComparison({
    required ExportSmartComparisonRequest request,
  });
}
