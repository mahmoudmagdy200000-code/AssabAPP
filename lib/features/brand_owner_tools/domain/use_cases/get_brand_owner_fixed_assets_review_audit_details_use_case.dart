import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_fixed_assets_review_audit_details_response.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class GetBrandOwnerFixedAssetsReviewAuditDetailsUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  GetBrandOwnerFixedAssetsReviewAuditDetailsUseCase(this._repository);

  FutureApiResult<BrandOwnerFixedAssetsReviewAuditDetailsResponse> call({
    required String requestId,
  }) {
    return _repository.getReviewAuditDetails(requestId: requestId);
  }
}