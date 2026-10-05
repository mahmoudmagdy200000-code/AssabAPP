import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_fixed_assets_disposal_and_external_transfer_request_model.dart';
import '../../../data/models/brand_owner_fixed_assets_handover_report_request_model.dart';
import '../../../data/models/brand_owner_fixed_assets_modification_request_model.dart';
import '../../../data/models/brand_owner_fixed_assets_review_audit_request_model.dart';
import '../../../data/models/brand_owner_fixed_assets_transfer_request_model.dart';

sealed class BrandOwnerFixedAssetsRequestsState {
  const BrandOwnerFixedAssetsRequestsState();
}

final class BrandOwnerFixedAssetsRequestsInitial
    extends BrandOwnerFixedAssetsRequestsState {
  const BrandOwnerFixedAssetsRequestsInitial();
}

final class BrandOwnerFixedAssetsReviewAuditRequestsLoading
    extends BrandOwnerFixedAssetsRequestsState {
  const BrandOwnerFixedAssetsReviewAuditRequestsLoading();
}

final class BrandOwnerFixedAssetsModificationRequestsLoading
    extends BrandOwnerFixedAssetsRequestsState {
  const BrandOwnerFixedAssetsModificationRequestsLoading();
}

final class BrandOwnerFixedAssetsHandoverReportsRequestsLoading
    extends BrandOwnerFixedAssetsRequestsState {
  const BrandOwnerFixedAssetsHandoverReportsRequestsLoading();
}

final class BrandOwnerFixedAssetsDisposalAndExternalTransferRequestsLoading
    extends BrandOwnerFixedAssetsRequestsState {
  const BrandOwnerFixedAssetsDisposalAndExternalTransferRequestsLoading();
}

final class BrandOwnerFixedAssetsTransferRequestsLoading
    extends BrandOwnerFixedAssetsRequestsState {
  const BrandOwnerFixedAssetsTransferRequestsLoading();
}

final class BrandOwnerFixedAssetsReviewAuditRequestsSuccess
    extends BrandOwnerFixedAssetsRequestsState {
  final List<BrandOwnerFixedAssetsReviewAuditRequestModel> requests;

  const BrandOwnerFixedAssetsReviewAuditRequestsSuccess(this.requests);
}

final class BrandOwnerFixedAssetsModificationRequestsSuccess
    extends BrandOwnerFixedAssetsRequestsState {
  final List<BrandOwnerFixedAssetsModificationRequestModel> requests;

  const BrandOwnerFixedAssetsModificationRequestsSuccess(this.requests);
}

final class BrandOwnerFixedAssetsHandoverReportsRequestsSuccess
    extends BrandOwnerFixedAssetsRequestsState {
  final List<BrandOwnerFixedAssetsHandoverReportRequestModel> requests;

  const BrandOwnerFixedAssetsHandoverReportsRequestsSuccess(this.requests);
}

final class BrandOwnerFixedAssetsDisposalAndExternalTransferRequestsSuccess
    extends BrandOwnerFixedAssetsRequestsState {
  final List<BrandOwnerFixedAssetsDisposalAndExternalTransferRequestModel>
  requests;

  const BrandOwnerFixedAssetsDisposalAndExternalTransferRequestsSuccess(
    this.requests,
  );
}

final class BrandOwnerFixedAssetsTransferRequestsSuccess
    extends BrandOwnerFixedAssetsRequestsState {
  final List<BrandOwnerFixedAssetsTransferRequestModel> requests;

  const BrandOwnerFixedAssetsTransferRequestsSuccess(this.requests);
}

final class BrandOwnerFixedAssetsReviewAuditRequestsFailure
    extends BrandOwnerFixedAssetsRequestsState {
  final ApiFailure failure;

  const BrandOwnerFixedAssetsReviewAuditRequestsFailure(this.failure);
}

final class BrandOwnerFixedAssetsModificationRequestsFailure
    extends BrandOwnerFixedAssetsRequestsState {
  final ApiFailure failure;

  const BrandOwnerFixedAssetsModificationRequestsFailure(this.failure);
}

final class BrandOwnerFixedAssetsHandoverReportsRequestsFailure
    extends BrandOwnerFixedAssetsRequestsState {
  final ApiFailure failure;

  const BrandOwnerFixedAssetsHandoverReportsRequestsFailure(this.failure);
}

final class BrandOwnerFixedAssetsDisposalAndExternalTransferRequestsFailure
    extends BrandOwnerFixedAssetsRequestsState {
  final ApiFailure failure;

  const BrandOwnerFixedAssetsDisposalAndExternalTransferRequestsFailure(
    this.failure,
  );
}

final class BrandOwnerFixedAssetsTransferRequestsFailure
    extends BrandOwnerFixedAssetsRequestsState {
  final ApiFailure failure;

  const BrandOwnerFixedAssetsTransferRequestsFailure(this.failure);
}