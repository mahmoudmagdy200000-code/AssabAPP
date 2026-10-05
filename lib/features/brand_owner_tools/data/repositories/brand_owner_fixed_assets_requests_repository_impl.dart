import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/brand_owner_fixed_assets_requests_repository.dart';
import '../datasources/brand_owner_fixed_assets_requests_remote_data_source.dart';
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

@LazySingleton(as: BrandOwnerFixedAssetsRequestsRepository)
class BrandOwnerFixedAssetsRequestsRepositoryImpl
    with RepositoryMixin
    implements BrandOwnerFixedAssetsRequestsRepository {
  final BrandOwnerFixedAssetsRequestsRemoteDataSource _dataSource;

  BrandOwnerFixedAssetsRequestsRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<List<BrandOwnerFixedAssetsReviewAuditRequestModel>>
  getReviewAuditRequests() {
    return execute(() async {
      final response = await _dataSource.getReviewAuditRequests();
      return response.data;
    });
  }

  @override
  FutureApiResult<BrandOwnerFixedAssetsReviewAuditDetailsResponse>
  getReviewAuditDetails({required String requestId}) {
    return execute(() async {
      return await _dataSource.getReviewAuditDetails(id: requestId);
    });
  }

  @override
  FutureApiResult<void> approveReviewAuditRequest({required String requestId}) {
    return execute(() async {
      return await _dataSource.approveReviewAuditRequest(id: requestId);
    });
  }

  @override
  FutureApiResult<void> rejectReviewAuditRequest({
    required String requestId,
    required String reason,
  }) {
    return execute(() async {
      return await _dataSource.rejectReviewAuditRequest(
        id: requestId,
        body: {'reason': reason},
      );
    });
  }

  @override
  FutureApiResult<BrandOwnerFixedAssetsModificationDetailsResponse>
  getModificationDetails({required String requestId}) {
    return execute(() async {
      return await _dataSource.getModificationDetails(id: requestId);
    });
  }

  @override
  FutureApiResult<void> approveModificationRequest({
    required String requestId,
  }) {
    return execute(() async {
      return await _dataSource.approveModificationRequest(id: requestId);
    });
  }

  @override
  FutureApiResult<void> rejectModificationRequest({
    required String requestId,
    required String reason,
  }) {
    return execute(() async {
      return await _dataSource.rejectModificationRequest(
        id: requestId,
        body: {'reason': reason},
      );
    });
  }

  @override
  FutureApiResult<BrandOwnerFixedAssetsHandoverReportDetailsResponse>
  getHandoverReportDetails({required String requestId}) {
    return execute(() async {
      return await _dataSource.getHandoverReportDetails(id: requestId);
    });
  }

  @override
  FutureApiResult<void> approveHandoverReportRequest({
    required String requestId,
    required String warningNote,
  }) {
    return execute(() async {
      return await _dataSource.approveHandoverReportRequest(
        id: requestId,
        body: {'warningNote': warningNote},
      );
    });
  }

  @override
  FutureApiResult<void> salaryDeductionHandoverReportRequest({
    required String requestId,
    required String amount,
    required String reason,
  }) {
    return execute(() async {
      return await _dataSource.salaryDeductionHandoverReportRequest(
        id: requestId,
        body: {'amount': amount, 'reason': reason},
      );
    });
  }

  @override
  FutureApiResult<List<BrandOwnerFixedAssetsModificationRequestModel>>
  getModificationRequests() {
    return execute(() async {
      final response = await _dataSource.getModificationRequests();
      return response.data;
    });
  }

  @override
  FutureApiResult<List<BrandOwnerFixedAssetsHandoverReportRequestModel>>
  getHandoverReportsRequests() {
    return execute(() async {
      final response = await _dataSource.getHandoverReportsRequests();
      return response.data;
    });
  }

  @override
  FutureApiResult<
    List<BrandOwnerFixedAssetsDisposalAndExternalTransferRequestModel>
  >
  getDisposalAndExternalTransferRequests() {
    return execute(() async {
      final response = await _dataSource
          .getDisposalAndExternalTransferRequests();
      return response.data;
    });
  }

  @override
  FutureApiResult<
    BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse
  >
  getDisposalAndExternalTransferDetails({required String requestId}) {
    return execute(() async {
      return await _dataSource.getDisposalAndExternalTransferDetails(
        id: requestId,
      );
    });
  }

  @override
  FutureApiResult<void> approveDisposalAndExternalTransferRequest({
    required String requestId,
  }) {
    return execute(() async {
      return await _dataSource.approveDisposalAndExternalTransferRequest(
        id: requestId,
      );
    });
  }

  @override
  FutureApiResult<void> rejectDisposalAndExternalTransferRequest({
    required String requestId,
    required String reason,
  }) {
    return execute(() async {
      return await _dataSource.rejectDisposalAndExternalTransferRequest(
        id: requestId,
        body: {'reason': reason},
      );
    });
  }

  @override
  FutureApiResult<List<BrandOwnerFixedAssetsTransferRequestModel>>
  getTransferRequests() {
    return execute(() async {
      final response = await _dataSource.getTransferRequests();
      return response.data;
    });
  }

  @override
  FutureApiResult<BrandOwnerFixedAssetsTransferDetailsResponse>
  getTransferDetails({required String requestId}) {
    return execute(() async {
      return await _dataSource.getTransferDetails(id: requestId);
    });
  }

  @override
  FutureApiResult<void> approveTransferRequest({required String requestId}) {
    return execute(() async {
      return await _dataSource.approveTransferRequest(id: requestId);
    });
  }

  @override
  FutureApiResult<void> rejectTransferRequest({
    required String requestId,
    required String reason,
  }) {
    return execute(() async {
      return await _dataSource.rejectTransferRequest(
        id: requestId,
        body: {'reason': reason},
      );
    });
  }
}
