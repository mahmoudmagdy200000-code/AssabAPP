import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/brand_owner_menu_engineering_entity.dart';
import '../repositories/brand_owner_menu_engineering_repository.dart';

@LazySingleton()
class GetMenuEngineeringUseCase {
  final BrandOwnerMenuEngineeringRepository _repository;

  GetMenuEngineeringUseCase(this._repository);

  Future<ApiResult<MenuEngineeringEntity>> call({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    String? branchId,
  }) {
    return _repository.getMenuEngineering(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      branchId: branchId,
    );
  }
}
