import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/brand_owner_fixed_assets_transfer_details_response.dart';
import '../../../domain/use_cases/get_brand_owner_fixed_assets_transfer_details_use_case.dart';
import '../../../domain/use_cases/approve_brand_owner_fixed_assets_transfer_use_case.dart';
import '../../../domain/use_cases/reject_brand_owner_fixed_assets_transfer_use_case.dart';
import 'brand_owner_transfer_details_state.dart';

@injectable
class BrandOwnerTransferDetailsCubit
    extends SafeCubit<BrandOwnerTransferDetailsState> {
  final GetBrandOwnerFixedAssetsTransferDetailsUseCase _getDetailsUseCase;
  final ApproveBrandOwnerFixedAssetsTransferUseCase _approveUseCase;
  final RejectBrandOwnerFixedAssetsTransferUseCase _rejectUseCase;

  BrandOwnerTransferDetailsCubit(
    this._getDetailsUseCase,
    this._approveUseCase,
    this._rejectUseCase,
  ) : super(const BrandOwnerTransferDetailsInitial());

  Future<void> load({required String requestId}) async {
    emit(const BrandOwnerTransferDetailsLoading());

    final result = await _getDetailsUseCase(requestId: requestId);

    handle(
      result,
      success: (details) => emit(BrandOwnerTransferDetailsSuccess(details)),
      failure: (failure) => emit(BrandOwnerTransferDetailsFailure(failure)),
    );
  }

  Future<void> approve({required String requestId}) async {
    final details = _currentDetails();
    if (details == null) return;

    emit(BrandOwnerTransferDetailsActionLoading(details, true));

    final result = await _approveUseCase(requestId: requestId);

    handle(
      result,
      failure: (failure) =>
          emit(BrandOwnerTransferDetailsActionFailure(details, failure, true)),
      success: (_) {
        emit(
          BrandOwnerTransferDetailsActionSuccess(details, true),
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

    emit(BrandOwnerTransferDetailsActionLoading(details, false));

    final result = await _rejectUseCase(requestId: requestId, reason: reason);

    handle(
      result,
      failure: (failure) =>
          emit(BrandOwnerTransferDetailsActionFailure(details, failure, false)),
      success: (_) {
        emit(
          BrandOwnerTransferDetailsActionSuccess(details, false),
        );
        load(requestId: requestId);
      },
    );
  }

  BrandOwnerFixedAssetsTransferDetailsResponse? _currentDetails() {
    return switch (state) {
      BrandOwnerTransferDetailsSuccess(:final details) ||
      BrandOwnerTransferDetailsActionLoading(:final details) ||
      BrandOwnerTransferDetailsActionSuccess(:final details) ||
      BrandOwnerTransferDetailsActionFailure(:final details) => details,
      _ => null,
    };
  }
}
