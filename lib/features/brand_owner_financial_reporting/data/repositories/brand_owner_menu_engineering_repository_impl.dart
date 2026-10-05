import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../domain/entities/brand_owner_menu_engineering_entity.dart';
import '../../domain/repositories/brand_owner_menu_engineering_repository.dart';
import '../datasources/brand_owner_menu_engineering_data_source.dart';
import '../models/export_menu_engineering_request.dart';

@LazySingleton(as: BrandOwnerMenuEngineeringRepository)
class BrandOwnerMenuEngineeringRepositoryImpl
    with RepositoryMixin
    implements BrandOwnerMenuEngineeringRepository {
  final BrandOwnerMenuEngineeringDataSource _dataSource;

  BrandOwnerMenuEngineeringRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<MenuEngineeringEntity> getMenuEngineering({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    String? branchId,
  }) {
    return execute(() async {
      return await _dataSource.getMenuEngineering(
        year: year,
        month: month,
        comparedYear: comparedYear,
        comparedMonth: comparedMonth,
        branchId: branchId,
      );
    });
  }

  @override
  FutureApiResult<String> exportMenuEngineering({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
  }) {
    return execute(() async {
      return await _dataSource.exportMenuEngineering(
        request: ExportMenuEngineeringRequest(
          year: year,
          month: month,
          comparedYear: comparedYear,
          comparedMonth: comparedMonth,
          branchId: branchId,
          formatType: 'pdf',
        ),
      );
    });
  }

  @override
  FutureApiResult<void> emailMenuEngineering({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
    required String email,
  }) {
    return execute(() async {
      return await _dataSource.emailMenuEngineering(
        request: ExportMenuEngineeringRequest(
          year: year,
          month: month,
          comparedYear: comparedYear,
          comparedMonth: comparedMonth,
          branchId: branchId,
          formatType: 'pdf',
          email: email,
        ),
      );
    });
  }
}
