import 'package:assab/core/utils/future_api_result.dart';

import '../../data/models/brand_owner_fixed_assets_disposal_and_external_transfer_details_response.dart';
import '../../data/models/brand_owner_fixed_assets_disposal_and_external_transfer_request_model.dart';
import '../../data/models/brand_owner_fixed_assets_handover_report_details_response.dart';
import '../../data/models/brand_owner_fixed_assets_handover_report_request_model.dart';
import '../../data/models/brand_owner_fixed_assets_modification_details_response.dart';
import '../../data/models/brand_owner_fixed_assets_review_audit_details_response.dart';
import '../../data/models/brand_owner_fixed_assets_modification_request_model.dart';
import '../../data/models/brand_owner_fixed_assets_review_audit_request_model.dart';
import '../../data/models/brand_owner_fixed_assets_transfer_details_response.dart';
import '../../data/models/brand_owner_fixed_assets_transfer_request_model.dart';

abstract class BrandOwnerFixedAssetsRequestsRepository {
  FutureApiResult<List<BrandOwnerFixedAssetsReviewAuditRequestModel>>
  getReviewAuditRequests();

  FutureApiResult<BrandOwnerFixedAssetsReviewAuditDetailsResponse>
  getReviewAuditDetails({required String requestId});

  FutureApiResult<void> approveReviewAuditRequest({required String requestId});

  FutureApiResult<void> rejectReviewAuditRequest({
    required String requestId,
    required String reason,
  });

  FutureApiResult<BrandOwnerFixedAssetsModificationDetailsResponse>
  getModificationDetails({required String requestId});

  FutureApiResult<void> approveModificationRequest({required String requestId});

  FutureApiResult<void> rejectModificationRequest({
    required String requestId,
    required String reason,
  });

  FutureApiResult<BrandOwnerFixedAssetsHandoverReportDetailsResponse>
  getHandoverReportDetails({required String requestId});

  FutureApiResult<void> approveHandoverReportRequest({
    required String requestId,
    required String warningNote,
  });

  FutureApiResult<void> salaryDeductionHandoverReportRequest({
    required String requestId,
    required String amount,
    required String reason,
  });

  FutureApiResult<List<BrandOwnerFixedAssetsModificationRequestModel>>
  getModificationRequests();

  FutureApiResult<List<BrandOwnerFixedAssetsHandoverReportRequestModel>>
  getHandoverReportsRequests();

  FutureApiResult<
    List<BrandOwnerFixedAssetsDisposalAndExternalTransferRequestModel>
  >
  getDisposalAndExternalTransferRequests();

  FutureApiResult<
    BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse
  >
  getDisposalAndExternalTransferDetails({required String requestId});

  FutureApiResult<void> approveDisposalAndExternalTransferRequest({
    required String requestId,
  });

  FutureApiResult<void> rejectDisposalAndExternalTransferRequest({
    required String requestId,
    required String reason,
  });

  FutureApiResult<List<BrandOwnerFixedAssetsTransferRequestModel>>
  getTransferRequests();

  FutureApiResult<BrandOwnerFixedAssetsTransferDetailsResponse>
  getTransferDetails({required String requestId});

  FutureApiResult<void> approveTransferRequest({required String requestId});

  FutureApiResult<void> rejectTransferRequest({
    required String requestId,
    required String reason,
  });
}
