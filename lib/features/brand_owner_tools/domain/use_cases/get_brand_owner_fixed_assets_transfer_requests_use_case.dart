import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/brand_owner_fixed_assets_transfer_request_model.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class GetBrandOwnerFixedAssetsTransferRequestsUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  GetBrandOwnerFixedAssetsTransferRequestsUseCase(this._repository);

  FutureApiResult<List<BrandOwnerFixedAssetsTransferRequestModel>> call() {
    return _repository.getTransferRequests();
  }
}
