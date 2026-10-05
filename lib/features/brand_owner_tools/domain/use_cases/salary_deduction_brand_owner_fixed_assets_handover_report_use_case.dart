import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_fixed_assets_handover_report_details_response.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class SalaryDeductionBrandOwnerFixedAssetsHandoverReportUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  SalaryDeductionBrandOwnerFixedAssetsHandoverReportUseCase(this._repository);

  FutureApiResult<void> call({
    required String requestId,
    required String amount,
    required String reason,
  }) {
    return _repository.salaryDeductionHandoverReportRequest(
      requestId: requestId,
      amount: amount,
      reason: reason,
    );
  }
}
