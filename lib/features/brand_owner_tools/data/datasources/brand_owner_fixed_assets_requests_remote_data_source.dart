import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../branch_manager_settings/data/models/brand_owner_settings_models.dart';
import '../models/brand_owner_fixed_assets_disposal_and_external_transfer_details_response.dart';
import '../models/brand_owner_fixed_assets_disposal_and_external_transfer_request_model.dart';
import '../models/brand_owner_fixed_assets_handover_report_details_response.dart';
import '../models/brand_owner_fixed_assets_handover_report_request_model.dart';
import '../models/brand_owner_fixed_assets_modification_details_response.dart';
import '../models/brand_owner_fixed_assets_modification_request_model.dart';
import '../models/brand_owner_fixed_assets_review_audit_details_response.dart';
import '../models/brand_owner_fixed_assets_review_audit_request_model.dart';
import '../models/brand_owner_fixed_assets_transfer_details_response.dart';
import '../models/brand_owner_fixed_assets_transfer_request_model.dart';

part 'brand_owner_fixed_assets_requests_remote_data_source.g.dart';

// =================== List Response Wrappers ===================

class BrandOwnerModificationRequestListResponse {
  final List<BrandOwnerFixedAssetsModificationRequestModel> data;
  const BrandOwnerModificationRequestListResponse({required this.data});

  factory BrandOwnerModificationRequestListResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerModificationRequestListResponse(
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => BrandOwnerFixedAssetsModificationRequestModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class BrandOwnerTransferRequestListResponse {
  final List<BrandOwnerFixedAssetsTransferRequestModel> data;
  const BrandOwnerTransferRequestListResponse({required this.data});

  factory BrandOwnerTransferRequestListResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerTransferRequestListResponse(
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => BrandOwnerFixedAssetsTransferRequestModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class BrandOwnerDisposalRequestListResponse {
  final List<BrandOwnerFixedAssetsDisposalAndExternalTransferRequestModel> data;
  const BrandOwnerDisposalRequestListResponse({required this.data});

  factory BrandOwnerDisposalRequestListResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerDisposalRequestListResponse(
      data: (json['data'] as List<dynamic>)
          .map(
            (e) =>
                BrandOwnerFixedAssetsDisposalAndExternalTransferRequestModel.fromJson(
                  e as Map<String, dynamic>,
                ),
          )
          .toList(),
    );
  }
}

class BrandOwnerHandoverReportListResponse {
  final List<BrandOwnerFixedAssetsHandoverReportRequestModel> data;
  const BrandOwnerHandoverReportListResponse({required this.data});

  factory BrandOwnerHandoverReportListResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerHandoverReportListResponse(
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => BrandOwnerFixedAssetsHandoverReportRequestModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class BrandOwnerReviewAuditListResponse {
  final List<BrandOwnerFixedAssetsReviewAuditRequestModel> data;
  const BrandOwnerReviewAuditListResponse({required this.data});

  factory BrandOwnerReviewAuditListResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerReviewAuditListResponse(
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => BrandOwnerFixedAssetsReviewAuditRequestModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

// =================== Remote Data Source ===================

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class BrandOwnerFixedAssetsRequestsRemoteDataSource {
  factory BrandOwnerFixedAssetsRequestsRemoteDataSource(
    Dio dio, {
    String baseUrl,
  }) = _BrandOwnerFixedAssetsRequestsRemoteDataSource;

  // =================== Modification ===================

  @GET(ApiEndpoint.brandOwnerFixedAssetsModificationRequests)
  Future<BrandOwnerModificationRequestListResponse> getModificationRequests();

  @GET(ApiEndpoint.brandOwnerFixedAssetsModificationDetails)
  Future<BrandOwnerFixedAssetsModificationDetailsResponse>
  getModificationDetails({@Path('id') required String id});

  @POST(ApiEndpoint.brandOwnerFixedAssetsModificationApprove)
  Future<void> approveModificationRequest({@Path('id') required String id});

  @POST(ApiEndpoint.brandOwnerFixedAssetsModificationReject)
  Future<void> rejectModificationRequest({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> body,
  });

  // =================== Transfer ===================

  @GET(ApiEndpoint.brandOwnerFixedAssetsTransferRequests)
  Future<BrandOwnerTransferRequestListResponse> getTransferRequests();

  @GET(ApiEndpoint.brandOwnerFixedAssetsTransferDetails)
  Future<BrandOwnerFixedAssetsTransferDetailsResponse> getTransferDetails({
    @Path('id') required String id,
  });

  @POST(ApiEndpoint.brandOwnerFixedAssetsTransferApprove)
  Future<void> approveTransferRequest({@Path('id') required String id});

  @POST(ApiEndpoint.brandOwnerFixedAssetsTransferReject)
  Future<void> rejectTransferRequest({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> body,
  });

  // =================== Disposal & External Transfer ===================

  @GET(ApiEndpoint.brandOwnerFixedAssetsDisposalRequests)
  Future<BrandOwnerDisposalRequestListResponse>
  getDisposalAndExternalTransferRequests();

  @GET(ApiEndpoint.brandOwnerFixedAssetsDisposalDetails)
  Future<BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse>
  getDisposalAndExternalTransferDetails({@Path('id') required String id});

  @POST(ApiEndpoint.brandOwnerFixedAssetsDisposalApprove)
  Future<void> approveDisposalAndExternalTransferRequest({
    @Path('id') required String id,
  });

  @POST(ApiEndpoint.brandOwnerFixedAssetsDisposalReject)
  Future<void> rejectDisposalAndExternalTransferRequest({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> body,
  });

  // =================== Handover Reports (Major Discrepancy) ===================

  @GET(ApiEndpoint.brandOwnerFixedAssetsHandoverReports)
  Future<BrandOwnerHandoverReportListResponse> getHandoverReportsRequests();

  @GET(ApiEndpoint.brandOwnerFixedAssetsHandoverReportsDetails)
  Future<BrandOwnerFixedAssetsHandoverReportDetailsResponse>
  getHandoverReportDetails({@Path('id') required String id});

  @POST(ApiEndpoint.brandOwnerFixedAssetsHandoverReportsApprove)
  Future<void> approveHandoverReportRequest({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> body,
  });

  @POST(ApiEndpoint.brandOwnerFixedAssetsHandoverReportsSalaryDeduction)
  Future<void> salaryDeductionHandoverReportRequest({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> body,
  });

  @POST(ApiEndpoint.brandOwnerFixedAssetsHandoverReportsReject)
  Future<void> rejectHandoverReportRequest({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> body,
  });

  // =================== Review & Audit ===================

  @GET(ApiEndpoint.brandOwnerFixedAssetsReviewAuditRequests)
  Future<BrandOwnerReviewAuditListResponse> getReviewAuditRequests();

  @GET(ApiEndpoint.brandOwnerFixedAssetsReviewAuditDetails)
  Future<BrandOwnerFixedAssetsReviewAuditDetailsResponse>
  getReviewAuditDetails({@Path('id') required String id});

  @POST(ApiEndpoint.brandOwnerFixedAssetsReviewAuditApprove)
  Future<void> approveReviewAuditRequest({@Path('id') required String id});

  @POST(ApiEndpoint.brandOwnerFixedAssetsReviewAuditReject)
  Future<void> rejectReviewAuditRequest({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> body,
  });

  // =================== Settings ===================

  @GET(ApiEndpoint.brandOwnerSettingsApproval)
  Future<BrandOwnerSettingApprovalModel> getApprovalSettings();

  @PATCH(ApiEndpoint.brandOwnerSettingsApproval)
  Future<void> updateApprovalSettings(@Body() Map<String, dynamic> body);

  @GET(ApiEndpoint.brandOwnerSettingsReport)
  Future<BrandOwnerReportSettingsModel> getReportSettings();

  @PATCH(ApiEndpoint.brandOwnerSettingsReport)
  Future<void> updateReportSettings(@Body() Map<String, dynamic> body);

  @GET(ApiEndpoint.brandOwnerSettingsSecurity)
  Future<BrandOwnerSecuritySettingsModel> getSecuritySettings();

  @PATCH(ApiEndpoint.brandOwnerSettingsSecurity)
  Future<void> updateSecuritySettings(@Body() Map<String, dynamic> body);

  @GET(ApiEndpoint.brandOwnerSettingsRetention)
  Future<BrandOwnerRetentionSettingsModel> getRetentionSettings();

  @PATCH(ApiEndpoint.brandOwnerSettingsRetention)
  Future<void> updateRetentionSettings(@Body() Map<String, dynamic> body);

  @GET(ApiEndpoint.brandOwnerSettingsNotifications)
  Future<BrandOwnerNotificationsSettingsModel> getNotificationsSettings();

  @PATCH(ApiEndpoint.brandOwnerSettingsNotifications)
  Future<void> updateNotificationsSettings(@Body() Map<String, dynamic> body);
}
