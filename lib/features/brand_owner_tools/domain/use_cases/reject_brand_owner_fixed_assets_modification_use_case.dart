import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_fixed_assets_modification_details_response.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class RejectBrandOwnerFixedAssetsModificationUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  RejectBrandOwnerFixedAssetsModificationUseCase(this._repository);

  FutureApiResult<void> call({
    required String requestId,
    required String reason,
  }) {
    return _repository.rejectModificationRequest(
      requestId: requestId,
      reason: reason,
    );
  }
}
