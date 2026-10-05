import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/brand_owner_fixed_assets_handover_report_request_model.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class GetBrandOwnerFixedAssetsHandoverReportsRequestsUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  GetBrandOwnerFixedAssetsHandoverReportsRequestsUseCase(this._repository);

  FutureApiResult<List<BrandOwnerFixedAssetsHandoverReportRequestModel>>
  call() {
    return _repository.getHandoverReportsRequests();
  }
}
