import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_fixed_assets_transfer_details_response.dart';

sealed class BrandOwnerTransferDetailsState {
  const BrandOwnerTransferDetailsState();
}

final class BrandOwnerTransferDetailsInitial
    extends BrandOwnerTransferDetailsState {
  const BrandOwnerTransferDetailsInitial();
}

final class BrandOwnerTransferDetailsLoading
    extends BrandOwnerTransferDetailsState {
  const BrandOwnerTransferDetailsLoading();
}

final class BrandOwnerTransferDetailsSuccess
    extends BrandOwnerTransferDetailsState {
  final BrandOwnerFixedAssetsTransferDetailsResponse details;

  const BrandOwnerTransferDetailsSuccess(this.details);
}

final class BrandOwnerTransferDetailsFailure
    extends BrandOwnerTransferDetailsState {
  final ApiFailure failure;

  const BrandOwnerTransferDetailsFailure(this.failure);
}

final class BrandOwnerTransferDetailsActionLoading
    extends BrandOwnerTransferDetailsState {
  final BrandOwnerFixedAssetsTransferDetailsResponse details;
  final bool isApprove;

  const BrandOwnerTransferDetailsActionLoading(this.details, this.isApprove);
}

final class BrandOwnerTransferDetailsActionSuccess
    extends BrandOwnerTransferDetailsState {
  final BrandOwnerFixedAssetsTransferDetailsResponse details;
  final bool isApprove;

  const BrandOwnerTransferDetailsActionSuccess(this.details, this.isApprove);
}

final class BrandOwnerTransferDetailsActionFailure
    extends BrandOwnerTransferDetailsState {
  final BrandOwnerFixedAssetsTransferDetailsResponse details;
  final ApiFailure failure;
  final bool isApprove;

  const BrandOwnerTransferDetailsActionFailure(
    this.details,
    this.failure,
    this.isApprove,
  );
}
