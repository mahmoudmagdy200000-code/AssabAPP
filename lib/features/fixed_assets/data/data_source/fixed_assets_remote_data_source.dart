import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/fixed_assets_active_handover_session_details_response.dart';
import '../models/fixed_assets_active_handover_session_preview_response.dart';
import '../models/fixed_assets_active_handover_session_signature_response.dart';
import '../models/fixed_assets_active_handover_session_summary_response.dart';
import '../models/fixed_assets_all_assets_response.dart';
import '../models/fixed_assets_branches_response.dart';
import '../models/fixed_asset_preview_asset_history_response.dart';
import '../models/fixed_asset_preview_generate_report_response.dart';
import '../models/fixed_assets_disposals_details_response.dart';
import '../models/fixed_assets_disposals_requests_response.dart';
import '../models/fixed_assets_handover_details_response.dart';
import '../models/fixed_assets_handover_included_zones_response.dart';
import '../models/fixed_assets_handovers_requests_response.dart';
import '../models/fixed_assets_join_handover_session_details_response.dart';
import '../models/fixed_assets_modification_requests_response.dart';
import '../models/fixed_assets_modify_details_response.dart';
import '../models/fixed_assets_overview_response.dart';
import '../models/fixed_assets_responsible_employee_response.dart';
import '../models/fixed_assets_search_request.dart';
import '../models/fixed_assets_search_response.dart';
import '../models/fixed_assets_start_handover_request.dart';
import '../models/fixed_assets_transfer_details_response.dart';
import '../models/fixed_assets_transfers_requests_response.dart';
import '../models/fixed_assets_types_response.dart';
import '../models/fixed_assets_zones_response.dart';
import '../models/receive_assets_respons.dart';

part 'fixed_assets_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class FixedAssetsRemoteDataSource {
  factory FixedAssetsRemoteDataSource(Dio dio, {String? baseUrl}) =
      _FixedAssetsRemoteDataSource;

  @GET(ApiEndpoint.fixedAssetsZones)
  Future<FixedAssetsZonesResponse> getZonesAssets();

  @GET(ApiEndpoint.fixedAssetsTypes)
  Future<FixedAssetsTypesResponse> getTypesAssets();

  @GET(ApiEndpoint.fixedAssetsEmployees)
  Future<FixedAssetsResponsibleEmployeeResponse> getResponsibleEmployees();

  @POST(ApiEndpoint.fixedAssetsSearch)
  Future<FixedAssetsSearchResponse> searchForAssets({
    @Body() required FixedAssetsSearchRequest request,
  });

  @GET('${ApiEndpoint.fixedAssetsReceiveAssets}/{requestId}')
  Future<ReceiveAssetsResponse> getReceiveAssets({
    @Path('requestId') required String requestId,
  });

  @POST('${ApiEndpoint.fixedAssetsReceiveAssetsConfirm}/{requestId}')
  Future<void> receiveAssets({
    @Path('requestId') required String requestId,
    @Body() required FormData formData,
  });

  @GET(ApiEndpoint.fixedAssetsModificationRequests)
  Future<FixedAssetsModificationRequestsResponse> getModificationRequests({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.fixedAssetsTransfersRequests)
  Future<FixedAssetsTransfersRequestsResponse> getTransfersRequests({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.fixedAssetsDisposalsRequests)
  Future<FixedAssetsDisposalsRequestsResponse> getDisposalsRequests({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.fixedAssetsHandoversRequests)
  Future<FixedAssetsHandoversRequestsResponse> getHandoverRequests({
    @Query('page') required int page,
  });

  @POST(ApiEndpoint.fixedAssetsModificationRequests)
  Future<void> modifyAssetStatus({@Body() required FormData formData});

  @GET('${ApiEndpoint.fixedAssetsModificationRequests}/{requestId}')
  Future<FixedAssetsModifyDetailsResponse> getModifyDetails({
    @Path('requestId') required String requestId,
  });

  @GET('${ApiEndpoint.fixedAssetsTransfersRequests}/{requestId}')
  Future<FixedAssetsTransferDetailsResponse> getTransferDetails({
    @Path('requestId') required String requestId,
  });

  @GET('${ApiEndpoint.fixedAssetsDisposalsRequests}/{requestId}')
  Future<FixedAssetsDisposalsDetailsResponse> getDisposalsDetails({
    @Path('requestId') required String requestId,
  });

  @POST('${ApiEndpoint.fixedAssetsAssets}/{assetId}/settings')
  Future<void> updateAssetSettings({
    @Path('assetId') required String assetId,
    @Body() required FormData formData,
  });

  @GET(ApiEndpoint.fixedAssetsBranches)
  Future<FixedAssetsBranchesResponse> getBranches();

  @GET(ApiEndpoint.fixedAssetsAssets)
  Future<FixedAssetsAllAssetsResponse> getAllAssets({
    @Query('search') String? search,
  });

  @GET(ApiEndpoint.fixedAssetsAssetHistory)
  Future<FixedAssetPreviewAssetHistoryResponse> getAssetHistoryPreview({
    @Path('assetId') required String assetId,
  });

  @POST(ApiEndpoint.fixedAssetsAssetHistoryReport)
  Future<FixedAssetPreviewGenerateReportResponse> generateAssetHistoryReport({
    @Path('assetId') required String assetId,
  });

  @POST(ApiEndpoint.fixedAssetsTransferDisposalRequests)
  Future<void> transferOrDisposeAssets({@Body() required FormData formData});

  // Handover
  @GET(ApiEndpoint.fixedAssetsOverview)
  Future<FixedAssetsOverviewResponse> getOverview();

  @GET(ApiEndpoint.fixedAssetsHandoverIncludedZones)
  Future<FixedAssetsHandoverIncludedZonesResponse> getHandoverIncludedZones({
    @Query('status_filter') String? statusFilter,
  });

  @POST(ApiEndpoint.fixedAssetsHandoverStart)
  Future<void> startHandover({
    @Body() required FixedAssetsStartHandoverRequest request,
  });

  @GET(ApiEndpoint.fixedAssetsHandoverSessionJoinDetails)
  Future<FixedAssetsJoinHandoverSessionDetailsResponse>
  getJoinHandoverSessionDetails({@Path('sessionId') required String sessionId});

  @POST(ApiEndpoint.fixedAssetsHandoverSessionJoin)
  Future<void> joinHandoverSession({
    @Path('sessionId') required String sessionId,
  });

  @GET(ApiEndpoint.fixedAssetsHandoverSessionDetails)
  Future<FixedAssetsActiveHandoverSessionDetailsResponse>
  getActiveHandoverSessionDetails({
    @Path('sessionId') required String sessionId,
  });

  @POST(ApiEndpoint.fixedAssetsHandoverSessionApproveZone)
  Future<void> approveActiveHandoverZone({
    @Path('sessionId') required String sessionId,
    @Body() required FormData formData,
  });

  @POST(ApiEndpoint.fixedAssetsHandoverSessionApproveAll)
  Future<void> approveAllActiveHandoverZones({
    @Path('sessionId') required String sessionId,
  });

  @POST(ApiEndpoint.fixedAssetsHandoverSessionSignatureReceiver)
  Future<void> confirmActiveHandoverSessionSignatureReceiver({
    @Path('sessionId') required String sessionId,
  });

  @POST(ApiEndpoint.fixedAssetsHandoverSessionSignatureSender)
  Future<void> confirmActiveHandoverSessionSignatureSender({
    @Path('sessionId') required String sessionId,
  });

  @GET(ApiEndpoint.fixedAssetsHandoverSessionSignature)
  Future<FixedAssetsActiveHandoverSessionSignatureResponse>
  getActiveHandoverSessionSignature({
    @Path('sessionId') required String sessionId,
  });

  @GET(ApiEndpoint.fixedAssetsHandoverSessionPreview)
  Future<FixedAssetsActiveHandoverSessionPreviewResponse>
  getActiveHandoverSessionPreview({
    @Path('sessionId') required String sessionId,
  });

  @GET(ApiEndpoint.fixedAssetsHandoverSessionSummary)
  Future<FixedAssetsActiveHandoverSessionSummaryResponse>
  getActiveHandoverSessionSummary({
    @Path('sessionId') required String sessionId,
  });

  @POST(ApiEndpoint.fixedAssetsHandoverSessionComplete)
  Future<void> completeActiveHandoverSession({
    @Path('sessionId') required String sessionId,
  });

  @GET(ApiEndpoint.fixedAssetsHandoverDetails)
  Future<FixedAssetsHandoverDetailsResponse> getHandoverDetails({
    @Path('handoverId') required String handoverId,
  });
}
