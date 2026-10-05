import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/use_cases/get_brand_owner_fixed_assets_disposal_and_external_transfer_requests_use_case.dart';
import '../../../domain/use_cases/get_brand_owner_fixed_assets_handover_reports_requests_use_case.dart';
import '../../../domain/use_cases/get_brand_owner_fixed_assets_modification_requests_use_case.dart';
import '../../../domain/use_cases/get_brand_owner_fixed_assets_review_audit_requests_use_case.dart';
import '../../../domain/use_cases/get_brand_owner_fixed_assets_transfer_requests_use_case.dart';
import 'brand_owner_fixed_assets_requests_state.dart';

@injectable
class BrandOwnerFixedAssetsRequestsCubit
    extends SafeCubit<BrandOwnerFixedAssetsRequestsState> {
  final GetBrandOwnerFixedAssetsReviewAuditRequestsUseCase
  _getReviewAuditRequestsUseCase;
  final GetBrandOwnerFixedAssetsModificationRequestsUseCase
  _getModificationRequestsUseCase;
  final GetBrandOwnerFixedAssetsHandoverReportsRequestsUseCase
  _getHandoverReportsRequestsUseCase;
  final GetBrandOwnerFixedAssetsDisposalAndExternalTransferRequestsUseCase
  _getDisposalAndExternalTransferRequestsUseCase;
  final GetBrandOwnerFixedAssetsTransferRequestsUseCase
  _getTransferRequestsUseCase;

  BrandOwnerFixedAssetsRequestsCubit(
    this._getReviewAuditRequestsUseCase,
    this._getModificationRequestsUseCase,
    this._getHandoverReportsRequestsUseCase,
    this._getDisposalAndExternalTransferRequestsUseCase,
    this._getTransferRequestsUseCase,
  ) : super(const BrandOwnerFixedAssetsRequestsInitial());

  Future<void> getReviewAuditRequests() async {
    emit(const BrandOwnerFixedAssetsReviewAuditRequestsLoading());

    final result = await _getReviewAuditRequestsUseCase();

    handle(
      result,
      success: (requests) =>
          emit(BrandOwnerFixedAssetsReviewAuditRequestsSuccess(requests)),
      failure: (failure) =>
          emit(BrandOwnerFixedAssetsReviewAuditRequestsFailure(failure)),
    );
  }

  Future<void> getModificationRequests() async {
    emit(const BrandOwnerFixedAssetsModificationRequestsLoading());

    final result = await _getModificationRequestsUseCase();

    handle(
      result,
      success: (requests) =>
          emit(BrandOwnerFixedAssetsModificationRequestsSuccess(requests)),
      failure: (failure) =>
          emit(BrandOwnerFixedAssetsModificationRequestsFailure(failure)),
    );
  }

  Future<void> getHandoverReportsRequests() async {
    emit(const BrandOwnerFixedAssetsHandoverReportsRequestsLoading());

    final result = await _getHandoverReportsRequestsUseCase();

    handle(
      result,
      success: (requests) =>
          emit(BrandOwnerFixedAssetsHandoverReportsRequestsSuccess(requests)),
      failure: (failure) =>
          emit(BrandOwnerFixedAssetsHandoverReportsRequestsFailure(failure)),
    );
  }

  Future<void> getDisposalAndExternalTransferRequests() async {
    emit(
      const BrandOwnerFixedAssetsDisposalAndExternalTransferRequestsLoading(),
    );

    final result = await _getDisposalAndExternalTransferRequestsUseCase();

    handle(
      result,
      success: (requests) => emit(
        BrandOwnerFixedAssetsDisposalAndExternalTransferRequestsSuccess(
          requests,
        ),
      ),
      failure: (failure) => emit(
        BrandOwnerFixedAssetsDisposalAndExternalTransferRequestsFailure(
          failure,
        ),
      ),
    );
  }

  Future<void> getTransferRequests() async {
    emit(const BrandOwnerFixedAssetsTransferRequestsLoading());

    final result = await _getTransferRequestsUseCase();

    handle(
      result,
      success: (requests) =>
          emit(BrandOwnerFixedAssetsTransferRequestsSuccess(requests)),
      failure: (failure) =>
          emit(BrandOwnerFixedAssetsTransferRequestsFailure(failure)),
    );
  }
}
