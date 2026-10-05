import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_daily_inventory_requests_response.dart';

sealed class BrandOwnerDailyInventoryRequestsState {
  const BrandOwnerDailyInventoryRequestsState();
}

final class BrandOwnerDailyInventoryRequestsInitial
    extends BrandOwnerDailyInventoryRequestsState {
  const BrandOwnerDailyInventoryRequestsInitial();
}

final class BrandOwnerDailyInventoryRequestsLoading
    extends BrandOwnerDailyInventoryRequestsState {
  const BrandOwnerDailyInventoryRequestsLoading();
}

final class BrandOwnerDailyInventoryRequestsSuccess
    extends BrandOwnerDailyInventoryRequestsState {
  final List<BrandOwnerDailyInventoryRequest> response;

  const BrandOwnerDailyInventoryRequestsSuccess(this.response);
}

final class BrandOwnerDailyInventoryRequestsFailure
    extends BrandOwnerDailyInventoryRequestsState {
  final ApiFailure failure;

  const BrandOwnerDailyInventoryRequestsFailure(this.failure);
}
