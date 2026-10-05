import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_fixed_assets_disposal_and_external_transfer_details_response.dart';

sealed class BrandOwnerDisposalAndExternalTransferDetailsState {
  const BrandOwnerDisposalAndExternalTransferDetailsState();
}

final class BrandOwnerDisposalAndExternalTransferDetailsInitial
    extends BrandOwnerDisposalAndExternalTransferDetailsState {
  const BrandOwnerDisposalAndExternalTransferDetailsInitial();
}

final class BrandOwnerDisposalAndExternalTransferDetailsLoading
    extends BrandOwnerDisposalAndExternalTransferDetailsState {
  const BrandOwnerDisposalAndExternalTransferDetailsLoading();
}

final class BrandOwnerDisposalAndExternalTransferDetailsSuccess
    extends BrandOwnerDisposalAndExternalTransferDetailsState {
  final BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse details;

  const BrandOwnerDisposalAndExternalTransferDetailsSuccess(this.details);
}

final class BrandOwnerDisposalAndExternalTransferDetailsFailure
    extends BrandOwnerDisposalAndExternalTransferDetailsState {
  final ApiFailure failure;

  const BrandOwnerDisposalAndExternalTransferDetailsFailure(this.failure);
}

final class BrandOwnerDisposalAndExternalTransferDetailsActionLoading
    extends BrandOwnerDisposalAndExternalTransferDetailsState {
  final BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse details;
  final bool isApprove;

  const BrandOwnerDisposalAndExternalTransferDetailsActionLoading(
    this.details,
    this.isApprove,
  );
}

final class BrandOwnerDisposalAndExternalTransferDetailsActionSuccess
    extends BrandOwnerDisposalAndExternalTransferDetailsState {
  final BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse details;
  final bool isApprove;

  const BrandOwnerDisposalAndExternalTransferDetailsActionSuccess(
    this.details,
    this.isApprove,
  );
}

final class BrandOwnerDisposalAndExternalTransferDetailsActionFailure
    extends BrandOwnerDisposalAndExternalTransferDetailsState {
  final BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse details;
  final ApiFailure failure;
  final bool isApprove;

  const BrandOwnerDisposalAndExternalTransferDetailsActionFailure(
    this.details,
    this.failure,
    this.isApprove,
  );
}
