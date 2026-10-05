import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../domain/entities/sales_channel_analysis_entity.dart';
import '../../domain/repositories/brand_owner_sales_channel_analysis_repository.dart';
import '../datasources/brand_owner_sales_channel_analysis_data_source.dart';
import '../models/export_sales_channel_analysis_request.dart';

@LazySingleton(as: BrandOwnerSalesChannelAnalysisRepository)
class BrandOwnerSalesChannelAnalysisRepositoryImpl
    with RepositoryMixin
    implements BrandOwnerSalesChannelAnalysisRepository {
  final BrandOwnerSalesChannelAnalysisDataSource _dataSource;

  BrandOwnerSalesChannelAnalysisRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<SalesChannelAnalysisEntity> getSalesChannelAnalysis({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    required String? branchId,
  }) {
    return execute(() async {
      return await _dataSource.getSalesChannelAnalysis(
        year: year,
        month: month,
        comparedYear: comparedYear,
        comparedMonth: comparedMonth,
        branchId: branchId,
      );
    });
  }

  @override
  FutureApiResult<String> exportSalesChannelAnalysis({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
    required String formatType,
  }) {
    return execute(() async {
      return await _dataSource.exportSalesChannelAnalysis(
        request: ExportSalesChannelAnalysisRequest(
          year: year,
          month: month,
          comparedYear: comparedYear,
          comparedMonth: comparedMonth,
          branchId: branchId,
          formatType: formatType,
        ),
      );
    });
  }

  @override
  FutureApiResult<void> emailSalesChannelAnalysis({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
    required String email,
  }) {
    return execute(() async {
      return await _dataSource.emailSalesChannelAnalysis(
        request: ExportSalesChannelAnalysisRequest(
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
