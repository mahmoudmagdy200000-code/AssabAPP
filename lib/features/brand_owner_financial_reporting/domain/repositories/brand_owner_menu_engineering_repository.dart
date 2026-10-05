import '../../../../core/utils/future_api_result.dart';
import '../entities/brand_owner_menu_engineering_entity.dart';

abstract class BrandOwnerMenuEngineeringRepository {
  FutureApiResult<MenuEngineeringEntity> getMenuEngineering({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    String? branchId,
  });

  FutureApiResult<String> exportMenuEngineering({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
  });

  FutureApiResult<void> emailMenuEngineering({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
    required String email,
  });
}
