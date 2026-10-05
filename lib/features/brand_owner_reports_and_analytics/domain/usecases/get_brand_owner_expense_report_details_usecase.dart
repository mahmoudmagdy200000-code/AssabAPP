import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/brand_owner_expense_report_details_entity.dart';
import '../entities/brand_owner_expense_report_filter_entity.dart';
import '../repositories/brand_owner_reports_and_analytics_repository.dart';

@LazySingleton()
class GetBrandOwnerExpenseReportDetailsUseCase {
  final BrandOwnerReportsAndAnalyticsRepository _repository;

  GetBrandOwnerExpenseReportDetailsUseCase(this._repository);

  Future<ApiResult<BrandOwnerExpenseReportDetailsEntity>> call({
    required String reportId,
    BrandOwnerExpenseReportFilterEntity? filters,
  }) {
    return _repository.getExpenseReportDetails(
      reportId: reportId,
      filters: filters,
    );
  }
}
