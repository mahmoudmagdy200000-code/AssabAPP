import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_fixed_assets_disposal_and_external_transfer_details_response.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class GetBrandOwnerFixedAssetsDisposalAndExternalTransferDetailsUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  GetBrandOwnerFixedAssetsDisposalAndExternalTransferDetailsUseCase(this._repository);

  FutureApiResult<BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse> call({
    required String requestId,
  }) {
    return _repository.getDisposalAndExternalTransferDetails(requestId: requestId);
  }
}
