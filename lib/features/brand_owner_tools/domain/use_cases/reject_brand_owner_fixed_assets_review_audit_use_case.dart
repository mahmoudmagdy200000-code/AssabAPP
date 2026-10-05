import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_fixed_assets_review_audit_details_response.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class RejectBrandOwnerFixedAssetsReviewAuditUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  RejectBrandOwnerFixedAssetsReviewAuditUseCase(this._repository);

  FutureApiResult<void> call({
    required String requestId,
    required String reason,
  }) {
    return _repository.rejectReviewAuditRequest(
      requestId: requestId,
      reason: reason,
    );
  }
}