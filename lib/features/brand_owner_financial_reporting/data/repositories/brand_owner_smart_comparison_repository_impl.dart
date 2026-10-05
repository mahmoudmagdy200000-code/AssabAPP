import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../domain/entities/smart_comparison_entity.dart';
import '../../domain/enums/brand_owner_smart_compare_type_enum.dart';
import '../../domain/repositories/brand_owner_smart_comparison_repository.dart';
import '../datasources/brand_owner_smart_comparison_data_source.dart';
import '../models/export_smart_comparison_request.dart';

@LazySingleton(as: BrandOwnerSmartComparisonRepository)
class BrandOwnerSmartComparisonRepositoryImpl
    with RepositoryMixin
    implements BrandOwnerSmartComparisonRepository {
  final BrandOwnerSmartComparisonDataSource _dataSource;

  BrandOwnerSmartComparisonRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<SmartComparisonEntity> getSmartComparison({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    required String? branchId,
    String? comparedBranchId,
  }) {
    return execute(() async {
      return await _dataSource.getSmartComparison(
        year: year,
        month: month,
        comparedYear: comparedYear,
        comparedMonth: comparedMonth,
        type: type,
        branchId: branchId,
        comparedBranchId: comparedBranchId,
      );
    });
  }

  @override
  FutureApiResult<String> exportSmartComparison({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    required String branchId,
    String? comparedBranchId,
    required String formatType,
  }) {
    return execute(() async {
      return await _dataSource.exportSmartComparison(
        request: ExportSmartComparisonRequest(
          year: year,
          month: month,
          comparedYear: comparedYear,
          comparedMonth: comparedMonth,
          type: type,
          branchId: branchId,
          comparedBranchId: comparedBranchId,
          formatType: formatType,
        ),
      );
    });
  }

  @override
  FutureApiResult<void> emailSmartComparison({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    required String branchId,
    String? comparedBranchId,
    required String email,
  }) {
    return execute(() async {
      return await _dataSource.emailSmartComparison(
        request: ExportSmartComparisonRequest(
          year: year,
          month: month,
          comparedYear: comparedYear,
          comparedMonth: comparedMonth,
          type: type,
          branchId: branchId,
          comparedBranchId: comparedBranchId,
          formatType: 'pdf',
          email: email,
        ),
      );
    });
  }
}
