import 'package:assab/core/errors/api_error_handler.dart';
import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/services/realtime_service/realtime_event.dart';
import 'package:assab/core/services/realtime_service/realtime_service.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/core/utils/stream_api_result.dart';
import 'package:injectable/injectable.dart';

import '../../domain/constants/fixed_assets_handover_realtime_events.dart';

import '../data_source/fixed_assets_remote_data_source.dart';
import '../models/fixed_assets_active_handover_session_signature_response.dart';
import '../models/fixed_assets_active_handover_session_summary_response.dart';
import '../models/fixed_assets_all_assets_response.dart';
import '../models/fixed_assets_active_handover_approve_zone_request.dart';
import '../models/fixed_assets_active_handover_session_details_response.dart';
import '../models/fixed_assets_active_handover_session_preview_response.dart';
import '../models/fixed_assets_branches_response.dart';
import '../models/fixed_asset_preview_asset_history_response.dart';
import '../models/fixed_asset_preview_generate_report_response.dart';
import '../models/fixed_assets_disposals_requests_response.dart';
import '../models/fixed_assets_disposals_details_response.dart';
import '../models/fixed_assets_handover_details_response.dart';
import '../models/fixed_assets_handover_included_zones_response.dart';
import '../models/fixed_assets_handovers_requests_response.dart';
import '../models/fixed_assets_join_handover_session_details_response.dart';
import '../models/fixed_assets_modification_requests_response.dart';
import '../models/fixed_assets_modify_details_response.dart';
import '../models/fixed_assets_modify_request.dart';
import '../models/fixed_assets_overview_response.dart';
import '../models/fixed_assets_responsible_employee_response.dart';
import '../models/fixed_assets_search_request.dart';
import '../models/fixed_assets_search_response.dart';
import '../models/fixed_assets_search_setting_request.dart';
import '../models/fixed_assets_start_handover_request.dart';
import '../models/fixed_assets_transfer_and_dispose_request.dart';
import '../models/fixed_assets_transfer_details_response.dart';
import '../models/fixed_assets_transfers_requests_response.dart';
import '../models/fixed_assets_types_response.dart';
import '../models/fixed_assets_zones_response.dart';
import '../models/receive_assets_request.dart';
import '../models/receive_assets_respons.dart';

@LazySingleton()
class FixedAssetsRepository with RepositoryMixin {
  final FixedAssetsRemoteDataSource _remoteDataSource;
  final RealtimeService _realtimeService;

  FixedAssetsRepository(this._remoteDataSource, this._realtimeService);

  FutureApiResult<FixedAssetsZonesResponse> getZonesAssets() async {
    return execute(_remoteDataSource.getZonesAssets);
  }

  FutureApiResult<FixedAssetsTypesResponse> getTypesAssets() async {
    return execute(_remoteDataSource.getTypesAssets);
  }

  FutureApiResult<FixedAssetsResponsibleEmployeeResponse>
  getResponsibleEmployees() async {
    return execute(_remoteDataSource.getResponsibleEmployees);
  }

  FutureApiResult<FixedAssetsSearchResponse> searchForAssets({
    required FixedAssetsSearchRequest request,
  }) async {
    return execute(() => _remoteDataSource.searchForAssets(request: request));
  }

  FutureApiResult<ReceiveAssetsResponse> getReceiveAssets({
    required String requestId,
  }) async {
    return execute(
      () => _remoteDataSource.getReceiveAssets(requestId: requestId),
    );
  }

  FutureApiResult<void> receiveAssets({
    required ReceiveAssetsRequest request,
  }) async {
    return execute(
      () => _remoteDataSource.receiveAssets(
        requestId: request.requestId,
        formData: request.toFormData(),
      ),
    );
  }

  FutureApiResult<FixedAssetsModificationRequestsResponse>
  getModificationRequests({required int page}) async {
    return execute(() => _remoteDataSource.getModificationRequests(page: page));
  }

  FutureApiResult<FixedAssetsTransfersRequestsResponse> getTransfersRequests({
    required int page,
  }) async {
    return execute(() => _remoteDataSource.getTransfersRequests(page: page));
  }

  FutureApiResult<FixedAssetsDisposalsRequestsResponse> getDisposalsRequests({
    required int page,
  }) async {
    return execute(() => _remoteDataSource.getDisposalsRequests(page: page));
  }

  FutureApiResult<FixedAssetsHandoversRequestsResponse> getHandoverRequests({
    required int page,
  }) async {
    return execute(() => _remoteDataSource.getHandoverRequests(page: page));
  }

  FutureApiResult<void> modifyAssetStatus({
    required FixedAssetsModifyRequest request,
  }) async {
    return execute(
      () async => _remoteDataSource.modifyAssetStatus(
        formData: await request.toFormData(),
      ),
    );
  }

  FutureApiResult<FixedAssetsModifyDetailsResponse> getModifyDetails({
    required String requestId,
  }) async {
    return execute(
      () => _remoteDataSource.getModifyDetails(requestId: requestId),
    );
  }

  FutureApiResult<FixedAssetsTransferDetailsResponse> getTransferDetails({
    required String requestId,
  }) async {
    return execute(
      () => _remoteDataSource.getTransferDetails(requestId: requestId),
    );
  }

  FutureApiResult<FixedAssetsDisposalsDetailsResponse> getDisposalsDetails({
    required String requestId,
  }) async {
    return execute(
      () => _remoteDataSource.getDisposalsDetails(requestId: requestId),
    );
  }

  FutureApiResult<void> updateAssetSettings({
    required FixedAssetsSearchSettingRequest request,
  }) async {
    return execute(
      () => _remoteDataSource.updateAssetSettings(
        assetId: request.assetId,
        formData: request.toFormData(),
      ),
    );
  }

  FutureApiResult<FixedAssetsBranchesResponse> getBranches() async {
    return execute(_remoteDataSource.getBranches);
  }

  FutureApiResult<FixedAssetsAllAssetsResponse> getAllAssets() async {
    return execute(_remoteDataSource.getAllAssets);
  }

  FutureApiResult<FixedAssetPreviewAssetHistoryResponse> getAssetHistory({
    required String assetId,
  }) async {
    return execute(
      () => _remoteDataSource.getAssetHistoryPreview(assetId: assetId),
    );
  }

  FutureApiResult<FixedAssetPreviewGenerateReportResponse>
  generateAssetHistoryReport({required String assetId}) async {
    return execute(
      () => _remoteDataSource.generateAssetHistoryReport(assetId: assetId),
    );
  }

  FutureApiResult<void> transferOrDisposeAssets({
    required FixedAssetsTransferAndDisposeRequest request,
  }) async {
    return execute(
      () => _remoteDataSource.transferOrDisposeAssets(
        formData: request.toFormData(),
      ),
    );
  }

  StreamApiResult<void> subscribeToHandoverSession({
    required String sessionId,
  }) {
    return _realtimeService
        .subscribe<void>(
          channel: FixedAssetsHandoverRealtimeChannels.handoverSession(
            sessionId,
          ),
          mapper: (json) => json,
        )
        .map<ApiResult<RealtimeEvent<void>>>(ApiResult.success)
        .handleError(
          (Object error, StackTrace stack) =>
              ApiResult<RealtimeEvent<void>>.failure(
                ApiErrorHandler.handle(error, stack),
              ),
        );
  }

  FutureApiResult<void> unsubscribeToHandoverSession({
    required String sessionId,
  }) => execute(() async {
    await _realtimeService.unsubscribe(
      FixedAssetsHandoverRealtimeChannels.handoverSession(sessionId),
    );
  });

  // Handover Section
  FutureApiResult<FixedAssetsOverviewResponse> getOverview() async {
    return execute(_remoteDataSource.getOverview);
  }

  FutureApiResult<FixedAssetsHandoverIncludedZonesResponse>
  getHandoverIncludedZones({required String statusFilter}) async {
    return execute(
      () => _remoteDataSource.getHandoverIncludedZones(
        statusFilter: statusFilter,
      ),
    );
  }

  FutureApiResult<void> startHandover({
    required FixedAssetsStartHandoverRequest request,
  }) async {
    return execute(() async {
      await _remoteDataSource.startHandover(request: request);
    });
  }

  FutureApiResult<FixedAssetsJoinHandoverSessionDetailsResponse>
  getJoinHandoverSessionDetails({required String sessionId}) async {
    return execute(
      () =>
          _remoteDataSource.getJoinHandoverSessionDetails(sessionId: sessionId),
    );
  }

  FutureApiResult<void> joinHandoverSession({required String sessionId}) async {
    return execute(
      () => _remoteDataSource.joinHandoverSession(sessionId: sessionId),
    );
  }

  FutureApiResult<FixedAssetsActiveHandoverSessionDetailsResponse>
  getActiveHandoverSessionDetails({required String sessionId}) async {
    return execute(
      () => _remoteDataSource.getActiveHandoverSessionDetails(
        sessionId: sessionId,
      ),
    );
  }

  FutureApiResult<FixedAssetsActiveHandoverSessionPreviewResponse>
  getActiveHandoverSessionPreview({required String sessionId}) async {
    return execute(
      () => _remoteDataSource.getActiveHandoverSessionPreview(
        sessionId: sessionId,
      ),
    );
  }

  FutureApiResult<void> approveActiveHandoverZone({
    required FixedAssetsActiveHandoverApproveZoneRequest request,
  }) async {
    return execute(
      () => _remoteDataSource.approveActiveHandoverZone(
        sessionId: request.sessionId,
        formData: request.toFormData(),
      ),
    );
  }

  FutureApiResult<void> approveAllActiveHandoverZones({
    required String sessionId,
  }) async {
    return execute(
      () =>
          _remoteDataSource.approveAllActiveHandoverZones(sessionId: sessionId),
    );
  }

  FutureApiResult<void> confirmActiveHandoverSessionSignatureReceiver({
    required String sessionId,
  }) async {
    return execute(
      () => _remoteDataSource.confirmActiveHandoverSessionSignatureReceiver(
        sessionId: sessionId,
      ),
    );
  }

  FutureApiResult<void> confirmActiveHandoverSessionSignatureSender({
    required String sessionId,
  }) async {
    return execute(
      () => _remoteDataSource.confirmActiveHandoverSessionSignatureSender(
        sessionId: sessionId,
      ),
    );
  }

  FutureApiResult<FixedAssetsActiveHandoverSessionSignatureResponse>
  getActiveHandoverSessionSignature({required String sessionId}) async {
    return execute(
      () => _remoteDataSource.getActiveHandoverSessionSignature(
        sessionId: sessionId,
      ),
    );
  }

  FutureApiResult<FixedAssetsActiveHandoverSessionSummaryResponse>
  getActiveHandoverSessionSummary({required String sessionId}) async {
    return execute(
      () => _remoteDataSource.getActiveHandoverSessionSummary(
        sessionId: sessionId,
      ),
    );
  }

  FutureApiResult<void> completeActiveHandoverSession({
    required String sessionId,
  }) async {
    return execute(
      () =>
          _remoteDataSource.completeActiveHandoverSession(sessionId: sessionId),
    );
  }

  FutureApiResult<FixedAssetsHandoverDetailsResponse> getHandoverDetails({
    required String handoverId,
  }) async {
    return execute(
      () => _remoteDataSource.getHandoverDetails(handoverId: handoverId),
    );
  }
}
