import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_fixed_assets_review_audit_details_response.dart';

sealed class BrandOwnerReviewAuditDetailsState {
  const BrandOwnerReviewAuditDetailsState();
}

final class BrandOwnerReviewAuditDetailsInitial
    extends BrandOwnerReviewAuditDetailsState {
  const BrandOwnerReviewAuditDetailsInitial();
}

final class BrandOwnerReviewAuditDetailsLoading
    extends BrandOwnerReviewAuditDetailsState {
  const BrandOwnerReviewAuditDetailsLoading();
}

final class BrandOwnerReviewAuditDetailsSuccess
    extends BrandOwnerReviewAuditDetailsState {
  final BrandOwnerFixedAssetsReviewAuditDetailsResponse details;

  const BrandOwnerReviewAuditDetailsSuccess(this.details);
}

final class BrandOwnerReviewAuditDetailsFailure
    extends BrandOwnerReviewAuditDetailsState {
  final ApiFailure failure;

  const BrandOwnerReviewAuditDetailsFailure(this.failure);
}

final class BrandOwnerReviewAuditDetailsActionLoading
    extends BrandOwnerReviewAuditDetailsState {
  final BrandOwnerFixedAssetsReviewAuditDetailsResponse details;
  final bool isApprove;

  const BrandOwnerReviewAuditDetailsActionLoading(
    this.details,
    this.isApprove,
  );
}

final class BrandOwnerReviewAuditDetailsActionSuccess
    extends BrandOwnerReviewAuditDetailsState {
  final BrandOwnerFixedAssetsReviewAuditDetailsResponse details;
  final bool isApprove;

  const BrandOwnerReviewAuditDetailsActionSuccess(
    this.details,
    this.isApprove,
  );
}

final class BrandOwnerReviewAuditDetailsActionFailure
    extends BrandOwnerReviewAuditDetailsState {
  final BrandOwnerFixedAssetsReviewAuditDetailsResponse details;
  final ApiFailure failure;
  final bool isApprove;

  const BrandOwnerReviewAuditDetailsActionFailure(
    this.details,
    this.failure,
    this.isApprove,
  );
}