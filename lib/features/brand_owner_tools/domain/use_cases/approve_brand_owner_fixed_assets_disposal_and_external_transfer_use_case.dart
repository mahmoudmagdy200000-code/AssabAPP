import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_fixed_assets_disposal_and_external_transfer_details_response.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class ApproveBrandOwnerFixedAssetsDisposalAndExternalTransferUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  ApproveBrandOwnerFixedAssetsDisposalAndExternalTransferUseCase(
    this._repository,
  );

  FutureApiResult<void> call({required String requestId}) {
    return _repository.approveDisposalAndExternalTransferRequest(
      requestId: requestId,
    );
  }
}
