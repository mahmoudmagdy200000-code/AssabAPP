import '../../../../core/utils/future_api_result.dart';
import '../entities/smart_comparison_entity.dart';
import '../enums/brand_owner_smart_compare_type_enum.dart';

abstract class BrandOwnerSmartComparisonRepository {
  FutureApiResult<SmartComparisonEntity> getSmartComparison({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    required String? branchId,
    String? comparedBranchId,
  });

  FutureApiResult<String> exportSmartComparison({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    required String branchId,
    String? comparedBranchId,
    required String formatType,
  });

  FutureApiResult<void> emailSmartComparison({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    required String branchId,
    String? comparedBranchId,
    required String email,
  });
}
