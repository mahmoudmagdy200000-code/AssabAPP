import 'package:assab/core/enums/brand_owner_inventory_action_type.dart';
import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_daily_inventory_details_response.dart';

sealed class BrandOwnerDailyInventoryDetailsState {
  const BrandOwnerDailyInventoryDetailsState();
}

final class BrandOwnerDailyInventoryDetailsInitial
    extends BrandOwnerDailyInventoryDetailsState {
  const BrandOwnerDailyInventoryDetailsInitial();
}

final class BrandOwnerDailyInventoryDetailsLoading
    extends BrandOwnerDailyInventoryDetailsState {
  const BrandOwnerDailyInventoryDetailsLoading();
}

final class BrandOwnerDailyInventoryDetailsSuccess
    extends BrandOwnerDailyInventoryDetailsState {
  final BrandOwnerDailyInventoryDetailsResponse details;

  const BrandOwnerDailyInventoryDetailsSuccess(this.details);
}

final class BrandOwnerDailyInventoryDetailsFailure
    extends BrandOwnerDailyInventoryDetailsState {
  final ApiFailure failure;

  const BrandOwnerDailyInventoryDetailsFailure(this.failure);
}

final class BrandOwnerDailyInventoryDetailsActionLoading
    extends BrandOwnerDailyInventoryDetailsState {
  final BrandOwnerDailyInventoryDetailsResponse details;
  final BrandOwnerInventoryActionType actionType;

  const BrandOwnerDailyInventoryDetailsActionLoading(
    this.details,
    this.actionType,
  );
}

final class BrandOwnerDailyInventoryDetailsActionSuccess
    extends BrandOwnerDailyInventoryDetailsState {
  final BrandOwnerDailyInventoryDetailsResponse details;
  final BrandOwnerInventoryActionType actionType;

  const BrandOwnerDailyInventoryDetailsActionSuccess(
    this.details,
    this.actionType,
  );
}

final class BrandOwnerDailyInventoryDetailsActionFailure
    extends BrandOwnerDailyInventoryDetailsState {
  final BrandOwnerDailyInventoryDetailsResponse details;
  final ApiFailure failure;
  final BrandOwnerInventoryActionType actionType;

  const BrandOwnerDailyInventoryDetailsActionFailure(
    this.details,
    this.failure,
    this.actionType,
  );
}
