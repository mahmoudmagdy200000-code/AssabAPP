import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/smart_comparison_entity.dart';
import '../enums/brand_owner_smart_compare_type_enum.dart';
import '../repositories/brand_owner_smart_comparison_repository.dart';

@LazySingleton()
class GetSmartComparisonUseCase {
  final BrandOwnerSmartComparisonRepository _repository;

  GetSmartComparisonUseCase(this._repository);

  Future<ApiResult<SmartComparisonEntity>> call({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    required String? branchId,
    String? comparedBranchId,
  }) {
    return _repository.getSmartComparison(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      type: type,
      branchId: branchId,
      comparedBranchId: comparedBranchId,
    );
  }
}
