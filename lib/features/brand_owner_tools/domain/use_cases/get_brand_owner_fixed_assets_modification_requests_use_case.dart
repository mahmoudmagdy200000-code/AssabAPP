import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/brand_owner_fixed_assets_modification_request_model.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class GetBrandOwnerFixedAssetsModificationRequestsUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  GetBrandOwnerFixedAssetsModificationRequestsUseCase(this._repository);

  FutureApiResult<List<BrandOwnerFixedAssetsModificationRequestModel>> call() {
    return _repository.getModificationRequests();
  }
}
