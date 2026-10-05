import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/brand_owner_fixed_assets_disposal_and_external_transfer_request_model.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class GetBrandOwnerFixedAssetsDisposalAndExternalTransferRequestsUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  GetBrandOwnerFixedAssetsDisposalAndExternalTransferRequestsUseCase(
    this._repository,
  );

  FutureApiResult<
    List<BrandOwnerFixedAssetsDisposalAndExternalTransferRequestModel>
  >
  call() {
    return _repository.getDisposalAndExternalTransferRequests();
  }
}
