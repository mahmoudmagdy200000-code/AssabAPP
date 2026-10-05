import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/brand_owner_custody_report_details_entity.dart';
import '../repositories/brand_owner_reports_and_analytics_repository.dart';

@LazySingleton()
class GetCustodyReportDetailsUseCase {
  final BrandOwnerReportsAndAnalyticsRepository _repository;

  GetCustodyReportDetailsUseCase(this._repository);

  Future<ApiResult<BrandOwnerCustodyReportDetailsEntity>> call({
    required String reportId,
  }) {
    return _repository.getCustodyReportDetails(reportId: reportId);
  }
}
