import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../domain/entities/brand_owner_custody_report_details_entity.dart';
import '../../domain/entities/brand_owner_expense_report_details_entity.dart';
import '../../domain/entities/brand_owner_expense_report_filter_entity.dart';
import '../../domain/entities/brand_owner_reports_and_analytics_entity.dart';
import '../../domain/repositories/brand_owner_reports_and_analytics_repository.dart';
import '../datasources/brand_owner_reports_and_analytics_remote_data_source.dart';
import '../models/brand_owner_expense_report_details_filter_model.dart';
import '../models/export_custody_report_request.dart';
import '../models/export_expense_report_request.dart';

@LazySingleton(as: BrandOwnerReportsAndAnalyticsRepository)
class BrandOwnerReportsAndAnalyticsRepositoryImpl
    with RepositoryMixin
    implements BrandOwnerReportsAndAnalyticsRepository {
  final BrandOwnerReportsAndAnalyticsRemoteDataSource _remoteDataSource;

  BrandOwnerReportsAndAnalyticsRepositoryImpl(this._remoteDataSource);

  @override
  FutureApiResult<BrandOwnerReportsAndAnalyticsEntity>
  getReportsAndAnalytics() {
    return execute(() async {
      final response = await _remoteDataSource.getReportsAndAnalytics();
      return response.toEntity();
    });
  }

  @override
  FutureApiResult<BrandOwnerExpenseReportDetailsEntity>
  getExpenseReportDetails({
    required String reportId,
    BrandOwnerExpenseReportFilterEntity? filters,
  }) {
    return execute(() async {
      final filterModel = BrandOwnerExpenseReportDetailsFilterModel.fromEntity(
        filters,
      );

      final response = await _remoteDataSource.getExpenseReportDetails(
        reportId: reportId,
        type: filterModel.type,
        status: filterModel.status,
        month: filterModel.month,
        year: filterModel.year,
        branchId: filterModel.branchId,
      );

      return response.toEntity();
    });
  }

  @override
  FutureApiResult<BrandOwnerCustodyReportDetailsEntity>
  getCustodyReportDetails({required String reportId}) {
    return execute(() async {
      final response = await _remoteDataSource.getCustodyReportDetails(
        reportId: reportId,
      );
      return response.toEntity();
    });
  }

  @override
  FutureApiResult<String> exportCustodyReport({
    required int year,
    required int monthNumber,
    required String formatType,
  }) {
    return execute(() async {
      final response = await _remoteDataSource.exportCustodyReport(
        request: ExportCustodyReportRequest(
          year: year,
          monthNumber: monthNumber,
          formatType: formatType,
        ),
      );

      return response.toEntity();
    });
  }

  @override
  FutureApiResult<String> exportExpenseReport({
    required int year,
    required int monthNumber,
    required String formatType,
    required String expenseType,
  }) {
    return execute(() async {
      final response = await _remoteDataSource.exportExpenseReport(
        request: ExportExpenseReportRequest(
          expenseType: expenseType,
          year: year,
          monthNumber: monthNumber,
          formatType: formatType,
        ),
      );

      return response.toEntity();
    });
  }
}
