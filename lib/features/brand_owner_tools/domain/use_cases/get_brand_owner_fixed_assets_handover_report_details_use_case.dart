import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_fixed_assets_handover_report_details_response.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class GetBrandOwnerFixedAssetsHandoverReportDetailsUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  GetBrandOwnerFixedAssetsHandoverReportDetailsUseCase(this._repository);

  FutureApiResult<BrandOwnerFixedAssetsHandoverReportDetailsResponse> call({
    required String requestId,
  }) {
    return _repository.getHandoverReportDetails(requestId: requestId);
  }
}
