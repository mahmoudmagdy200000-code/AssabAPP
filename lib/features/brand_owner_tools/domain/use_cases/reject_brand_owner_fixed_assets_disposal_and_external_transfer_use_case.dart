import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_fixed_assets_disposal_and_external_transfer_details_response.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class RejectBrandOwnerFixedAssetsDisposalAndExternalTransferUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  RejectBrandOwnerFixedAssetsDisposalAndExternalTransferUseCase(
    this._repository,
  );

  FutureApiResult<void> call({
    required String requestId,
    required String reason,
  }) {
    return _repository.rejectDisposalAndExternalTransferRequest(
      requestId: requestId,
      reason: reason,
    );
  }
}
