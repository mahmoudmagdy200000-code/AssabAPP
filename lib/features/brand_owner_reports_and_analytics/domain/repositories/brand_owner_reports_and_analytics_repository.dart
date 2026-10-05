import '../../../../core/utils/future_api_result.dart';
import '../entities/brand_owner_custody_report_details_entity.dart';
import '../entities/brand_owner_expense_report_details_entity.dart';
import '../entities/brand_owner_expense_report_filter_entity.dart';
import '../entities/brand_owner_reports_and_analytics_entity.dart';

abstract class BrandOwnerReportsAndAnalyticsRepository {
  FutureApiResult<BrandOwnerReportsAndAnalyticsEntity> getReportsAndAnalytics();

  FutureApiResult<BrandOwnerExpenseReportDetailsEntity> getExpenseReportDetails({
    required String reportId,
    BrandOwnerExpenseReportFilterEntity? filters,
  });

  FutureApiResult<BrandOwnerCustodyReportDetailsEntity> getCustodyReportDetails({
    required String reportId,
  });

  FutureApiResult<String> exportCustodyReport({
    required int year,
    required int monthNumber,
    required String formatType,
  });

  FutureApiResult<String> exportExpenseReport({
    required int year,
    required int monthNumber,
    required String formatType,
    required String expenseType,
  });
}
