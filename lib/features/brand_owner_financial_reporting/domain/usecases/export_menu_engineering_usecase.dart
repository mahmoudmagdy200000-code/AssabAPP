import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../repositories/brand_owner_menu_engineering_repository.dart';

@LazySingleton()
class ExportMenuEngineeringUseCase {
  final BrandOwnerMenuEngineeringRepository _repository;

  ExportMenuEngineeringUseCase(this._repository);

  Future<ApiResult<String>> call({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
  }) {
    return _repository.exportMenuEngineering(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      branchId: branchId,
    );
  }

  Future<ApiResult<void>> emailReport({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
    required String email,
  }) {
    return _repository.emailMenuEngineering(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      branchId: branchId,
      email: email,
    );
  }
}
