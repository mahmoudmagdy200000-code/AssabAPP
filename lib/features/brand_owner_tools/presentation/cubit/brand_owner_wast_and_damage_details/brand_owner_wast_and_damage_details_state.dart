import 'package:assab/core/enums/brand_owner_inventory_action_type.dart';
import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_wast_and_damage_details_response.dart';

sealed class BrandOwnerWastAndDamageDetailsState {
  const BrandOwnerWastAndDamageDetailsState();
}

final class BrandOwnerWastAndDamageDetailsInitial
    extends BrandOwnerWastAndDamageDetailsState {
  const BrandOwnerWastAndDamageDetailsInitial();
}

final class BrandOwnerWastAndDamageDetailsLoading
    extends BrandOwnerWastAndDamageDetailsState {
  const BrandOwnerWastAndDamageDetailsLoading();
}

final class BrandOwnerWastAndDamageDetailsSuccess
    extends BrandOwnerWastAndDamageDetailsState {
  final BrandOwnerWastAndDamageDetailsResponse details;

  const BrandOwnerWastAndDamageDetailsSuccess(this.details);
}

final class BrandOwnerWastAndDamageDetailsFailure
    extends BrandOwnerWastAndDamageDetailsState {
  final ApiFailure failure;

  const BrandOwnerWastAndDamageDetailsFailure(this.failure);
}

final class BrandOwnerWastAndDamageDetailsActionLoading
    extends BrandOwnerWastAndDamageDetailsState {
  final BrandOwnerWastAndDamageDetailsResponse details;
  final BrandOwnerInventoryActionType actionType;

  const BrandOwnerWastAndDamageDetailsActionLoading(
    this.details,
    this.actionType,
  );
}

final class BrandOwnerWastAndDamageDetailsActionSuccess
    extends BrandOwnerWastAndDamageDetailsState {
  final BrandOwnerWastAndDamageDetailsResponse details;
  final BrandOwnerInventoryActionType actionType;

  const BrandOwnerWastAndDamageDetailsActionSuccess(
    this.details,
    this.actionType,
  );
}

final class BrandOwnerWastAndDamageDetailsActionFailure
    extends BrandOwnerWastAndDamageDetailsState {
  final BrandOwnerWastAndDamageDetailsResponse details;
  final ApiFailure failure;
  final BrandOwnerInventoryActionType actionType;

  const BrandOwnerWastAndDamageDetailsActionFailure(
    this.details,
    this.failure,
    this.actionType,
  );
}
