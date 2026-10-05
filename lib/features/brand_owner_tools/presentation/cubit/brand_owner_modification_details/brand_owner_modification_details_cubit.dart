import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/brand_owner_fixed_assets_modification_details_response.dart';
import '../../../domain/use_cases/approve_brand_owner_fixed_assets_modification_use_case.dart';
import '../../../domain/use_cases/get_brand_owner_fixed_assets_modification_details_use_case.dart';
import '../../../domain/use_cases/reject_brand_owner_fixed_assets_modification_use_case.dart';
import 'brand_owner_modification_details_state.dart';

@injectable
class BrandOwnerModificationDetailsCubit
    extends SafeCubit<BrandOwnerModificationDetailsState> {
  final GetBrandOwnerFixedAssetsModificationDetailsUseCase _getDetailsUseCase;
  final ApproveBrandOwnerFixedAssetsModificationUseCase _approveUseCase;
  final RejectBrandOwnerFixedAssetsModificationUseCase _rejectUseCase;

  BrandOwnerModificationDetailsCubit(
    this._getDetailsUseCase,
    this._approveUseCase,
    this._rejectUseCase,
  ) : super(const BrandOwnerModificationDetailsInitial());

  Future<void> load({required String requestId}) async {
    emit(const BrandOwnerModificationDetailsLoading());

    final result = await _getDetailsUseCase(requestId: requestId);

    handle(
      result,
      success: (details) => emit(BrandOwnerModificationDetailsSuccess(details)),
      failure: (failure) => emit(BrandOwnerModificationDetailsFailure(failure)),
    );
  }

  Future<void> approve({required String requestId}) async {
    final details = _currentDetails();
    if (details == null) return;

    emit(BrandOwnerModificationDetailsActionLoading(details, true));

    final result = await _approveUseCase(requestId: requestId);

    handle(
      result,
      failure: (failure) => emit(
        BrandOwnerModificationDetailsActionFailure(details, failure, true),
      ),
      success: (_) {
        emit(
          BrandOwnerModificationDetailsActionSuccess(details, true),
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

    emit(BrandOwnerModificationDetailsActionLoading(details, false));

    final result = await _rejectUseCase(requestId: requestId, reason: reason);

    handle(
      result,
      failure: (failure) => emit(
        BrandOwnerModificationDetailsActionFailure(details, failure, false),
      ),
      success: (_) {
        emit(
          BrandOwnerModificationDetailsActionSuccess(details, false),
        );
        load(requestId: requestId);
      },
    );
  }

  BrandOwnerFixedAssetsModificationDetailsResponse? _currentDetails() {
    return switch (state) {
      BrandOwnerModificationDetailsSuccess(:final details) ||
      BrandOwnerModificationDetailsActionLoading(:final details) ||
      BrandOwnerModificationDetailsActionSuccess(:final details) ||
      BrandOwnerModificationDetailsActionFailure(:final details) => details,
      _ => null,
    };
  }
}
