import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/brand_owner_fixed_assets_review_audit_request_model.dart';
import '../repositories/brand_owner_fixed_assets_requests_repository.dart';

@LazySingleton()
class GetBrandOwnerFixedAssetsReviewAuditRequestsUseCase {
  final BrandOwnerFixedAssetsRequestsRepository _repository;

  GetBrandOwnerFixedAssetsReviewAuditRequestsUseCase(this._repository);

  FutureApiResult<List<BrandOwnerFixedAssetsReviewAuditRequestModel>> call() {
    return _repository.getReviewAuditRequests();
  }
}
