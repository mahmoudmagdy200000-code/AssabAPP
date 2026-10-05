import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_fixed_assets_modification_details_response.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class GetBrandOwnerFixedAssetsModificationDetailsUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  GetBrandOwnerFixedAssetsModificationDetailsUseCase(this._repository);

  FutureApiResult<BrandOwnerFixedAssetsModificationDetailsResponse> call({
    required String requestId,
  }) {
    return _repository.getModificationDetails(requestId: requestId);
  }
}
