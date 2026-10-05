import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_wast_and_damage_requests_response.dart';

sealed class BrandOwnerWastAndDamageRequestsState {
  const BrandOwnerWastAndDamageRequestsState();
}

final class BrandOwnerWastAndDamageRequestsInitial
    extends BrandOwnerWastAndDamageRequestsState {
  const BrandOwnerWastAndDamageRequestsInitial();
}

final class BrandOwnerWastAndDamageRequestsLoading
    extends BrandOwnerWastAndDamageRequestsState {
  const BrandOwnerWastAndDamageRequestsLoading();
}

final class BrandOwnerWastAndDamageRequestsSuccess
    extends BrandOwnerWastAndDamageRequestsState {
  final List<BrandOwnerWastAndDamageRequest> response;

  const BrandOwnerWastAndDamageRequestsSuccess(this.response);
}

final class BrandOwnerWastAndDamageRequestsFailure
    extends BrandOwnerWastAndDamageRequestsState {
  final ApiFailure failure;

  const BrandOwnerWastAndDamageRequestsFailure(this.failure);
}
