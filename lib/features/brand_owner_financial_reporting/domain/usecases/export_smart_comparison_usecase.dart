import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../enums/brand_owner_smart_compare_type_enum.dart';
import '../repositories/brand_owner_smart_comparison_repository.dart';

@LazySingleton()
class ExportSmartComparisonUseCase {
  final BrandOwnerSmartComparisonRepository _repository;

  ExportSmartComparisonUseCase(this._repository);

  Future<ApiResult<String>> call({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    required String branchId,
    String? comparedBranchId,
    required String formatType,
  }) {
    return _repository.exportSmartComparison(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      type: type,
      branchId: branchId,
      comparedBranchId: comparedBranchId,
      formatType: formatType,
    );
  }

  Future<ApiResult<void>> emailReport({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    required String branchId,
    String? comparedBranchId,
    required String email,
  }) {
    return _repository.emailSmartComparison(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      type: type,
      branchId: branchId,
      comparedBranchId: comparedBranchId,
      email: email,
    );
  }
}
