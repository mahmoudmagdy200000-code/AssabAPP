import '../models/brand_owner_menu_engineering_model.dart';
import '../models/export_menu_engineering_request.dart';

abstract class BrandOwnerMenuEngineeringDataSource {
  Future<MenuEngineeringModel> getMenuEngineering({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    String? branchId,
  });

  Future<String> exportMenuEngineering({
    required ExportMenuEngineeringRequest request,
  });

  Future<void> emailMenuEngineering({
    required ExportMenuEngineeringRequest request,
  });
}
