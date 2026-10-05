import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_fixed_assets_modification_details_response.dart';

sealed class BrandOwnerModificationDetailsState {
  const BrandOwnerModificationDetailsState();
}

final class BrandOwnerModificationDetailsInitial
    extends BrandOwnerModificationDetailsState {
  const BrandOwnerModificationDetailsInitial();
}

final class BrandOwnerModificationDetailsLoading
    extends BrandOwnerModificationDetailsState {
  const BrandOwnerModificationDetailsLoading();
}

final class BrandOwnerModificationDetailsSuccess
    extends BrandOwnerModificationDetailsState {
  final BrandOwnerFixedAssetsModificationDetailsResponse details;

  const BrandOwnerModificationDetailsSuccess(this.details);
}

final class BrandOwnerModificationDetailsFailure
    extends BrandOwnerModificationDetailsState {
  final ApiFailure failure;

  const BrandOwnerModificationDetailsFailure(this.failure);
}

final class BrandOwnerModificationDetailsActionLoading
    extends BrandOwnerModificationDetailsState {
  final BrandOwnerFixedAssetsModificationDetailsResponse details;
  final bool isApprove;

  const BrandOwnerModificationDetailsActionLoading(
    this.details,
    this.isApprove,
  );
}

final class BrandOwnerModificationDetailsActionSuccess
    extends BrandOwnerModificationDetailsState {
  final BrandOwnerFixedAssetsModificationDetailsResponse details;
  final bool isApprove;

  const BrandOwnerModificationDetailsActionSuccess(
    this.details,
    this.isApprove,
  );
}

final class BrandOwnerModificationDetailsActionFailure
    extends BrandOwnerModificationDetailsState {
  final BrandOwnerFixedAssetsModificationDetailsResponse details;
  final ApiFailure failure;
  final bool isApprove;

  const BrandOwnerModificationDetailsActionFailure(
    this.details,
    this.failure,
    this.isApprove,
  );
}
