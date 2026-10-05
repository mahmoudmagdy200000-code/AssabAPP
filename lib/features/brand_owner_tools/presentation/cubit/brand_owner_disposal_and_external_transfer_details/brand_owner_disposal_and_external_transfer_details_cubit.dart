import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/brand_owner_fixed_assets_disposal_and_external_transfer_details_response.dart';
import '../../../domain/use_cases/get_brand_owner_fixed_assets_disposal_and_external_transfer_details_use_case.dart';
import '../../../domain/use_cases/approve_brand_owner_fixed_assets_disposal_and_external_transfer_use_case.dart';
import '../../../domain/use_cases/reject_brand_owner_fixed_assets_disposal_and_external_transfer_use_case.dart';
import 'brand_owner_disposal_and_external_transfer_details_state.dart';

@injectable
class BrandOwnerDisposalAndExternalTransferDetailsCubit
    extends SafeCubit<BrandOwnerDisposalAndExternalTransferDetailsState> {
  final GetBrandOwnerFixedAssetsDisposalAndExternalTransferDetailsUseCase
  _getDetailsUseCase;
  final ApproveBrandOwnerFixedAssetsDisposalAndExternalTransferUseCase
  _approveUseCase;
  final RejectBrandOwnerFixedAssetsDisposalAndExternalTransferUseCase
  _rejectUseCase;

  BrandOwnerDisposalAndExternalTransferDetailsCubit(
    this._getDetailsUseCase,
    this._approveUseCase,
    this._rejectUseCase,
  ) : super(const BrandOwnerDisposalAndExternalTransferDetailsInitial());

  Future<void> load({required String requestId}) async {
    emit(const BrandOwnerDisposalAndExternalTransferDetailsLoading());

    final result = await _getDetailsUseCase(requestId: requestId);

    handle(
      result,
      success: (details) =>
          emit(BrandOwnerDisposalAndExternalTransferDetailsSuccess(details)),
      failure: (failure) =>
          emit(BrandOwnerDisposalAndExternalTransferDetailsFailure(failure)),
    );
  }

  Future<void> approve({required String requestId}) async {
    final details = _currentDetails();
    if (details == null) return;

    emit(
      BrandOwnerDisposalAndExternalTransferDetailsActionLoading(details, true),
    );

    final result = await _approveUseCase(requestId: requestId);

    handle(
      result,
      failure: (failure) => emit(
        BrandOwnerDisposalAndExternalTransferDetailsActionFailure(
          details,
          failure,
          true,
        ),
      ),
      success: (_) {
        emit(
          BrandOwnerDisposalAndExternalTransferDetailsActionSuccess(
            details,
            true,
          ),
        );
        load(requestId: requestId);
      },
    );
  }

  Future<void> reject({
    required String requestId,
    required String reason,
  }) async {
    final details = _currentDetails();
    if (details == null) return;

    emit(
      BrandOwnerDisposalAndExternalTransferDetailsActionLoading(details, false),
    );

    final result = await _rejectUseCase(requestId: requestId, reason: reason);

    handle(
      result,
      failure: (failure) => emit(
        BrandOwnerDisposalAndExternalTransferDetailsActionFailure(
          details,
          failure,
          false,
        ),
      ),
      success: (_) {
        emit(
          BrandOwnerDisposalAndExternalTransferDetailsActionSuccess(
            details,
            false,
          ),
        );
        load(requestId: requestId);
      },
    );
  }

  BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse?
  _currentDetails() {
    return switch (state) {
      BrandOwnerDisposalAndExternalTransferDetailsSuccess(:final details) ||
      BrandOwnerDisposalAndExternalTransferDetailsActionLoading(
        :final details,
      ) ||
      BrandOwnerDisposalAndExternalTransferDetailsActionSuccess(
        :final details,
      ) ||
      BrandOwnerDisposalAndExternalTransferDetailsActionFailure(
        :final details,
      ) => details,
      _ => null,
    };
  }
}
