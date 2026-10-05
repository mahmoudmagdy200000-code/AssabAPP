import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../domain/entities/brand_owner_break_even_analysis_entity.dart';
import '../../domain/repositories/brand_owner_break_even_analysis_repository.dart';
import '../datasources/brand_owner_break_even_analysis_data_source.dart';
import '../models/export_break_even_analysis_request.dart';

@LazySingleton(as: BrandOwnerBreakEvenAnalysisRepository)
class BrandOwnerBreakEvenAnalysisRepositoryImpl
    with RepositoryMixin
    implements BrandOwnerBreakEvenAnalysisRepository {
  final BrandOwnerBreakEvenAnalysisDataSource _dataSource;

  BrandOwnerBreakEvenAnalysisRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<BreakEvenAnalysisEntity> getBreakEvenAnalysis({
    int? year,
    int? month,
    required String branchId,
  }) {
    return execute(() async {
      return await _dataSource.getBreakEvenAnalysis(
        year: year,
        month: month,
        branchId: branchId,
      );
    });
  }

  @override
  FutureApiResult<String> exportBreakEvenAnalysis({
    required int year,
    required int month,
    required String branchId,
    required String formatType,
  }) {
    return execute(() async {
      return await _dataSource.exportBreakEvenAnalysis(
        request: ExportBreakEvenAnalysisRequest(
          year: year,
          month: month,
          branchId: branchId,
          formatType: formatType,
        ),
      );
    });
  }
}
