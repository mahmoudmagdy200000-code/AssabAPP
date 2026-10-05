import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_fixed_assets_transfer_details_response.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class RejectBrandOwnerFixedAssetsTransferUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  RejectBrandOwnerFixedAssetsTransferUseCase(this._repository);

  FutureApiResult<void> call({
    required String requestId,
    required String reason,
  }) {
    return _repository.rejectTransferRequest(
      requestId: requestId,
      reason: reason,
    );
  }
}
