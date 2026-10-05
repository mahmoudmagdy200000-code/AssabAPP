import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_fixed_assets_transfer_details_response.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class ApproveBrandOwnerFixedAssetsTransferUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  ApproveBrandOwnerFixedAssetsTransferUseCase(this._repository);

  FutureApiResult<void> call({required String requestId}) {
    return _repository.approveTransferRequest(requestId: requestId);
  }
}
