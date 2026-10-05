import 'package:injectable/injectable.dart';

import '../../../../../core/enums/brand_owner_inventory_action_type.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/brand_owner_wast_and_damage_details_response.dart';
import '../../../domain/use_cases/approve_brand_owner_wast_and_damage_use_case.dart';
import '../../../domain/use_cases/get_brand_owner_wast_and_damage_details_use_case.dart';
import '../../../domain/use_cases/reject_brand_owner_wast_and_damage_use_case.dart';
import 'brand_owner_wast_and_damage_details_state.dart';

@injectable
class BrandOwnerWastAndDamageDetailsCubit
    extends SafeCubit<BrandOwnerWastAndDamageDetailsState> {
  final GetBrandOwnerWastAndDamageDetailsUseCase _getDetailsUseCase;
  final ApproveBrandOwnerWastAndDamageUseCase _approveUseCase;
  final RejectBrandOwnerWastAndDamageUseCase _rejectUseCase;

  BrandOwnerWastAndDamageDetailsCubit(
    this._getDetailsUseCase,
    this._approveUseCase,
    this._rejectUseCase,
  ) : super(const BrandOwnerWastAndDamageDetailsInitial());

  Future<void> load({required String requestId}) async {
    emit(const BrandOwnerWastAndDamageDetailsLoading());

    final result = await _getDetailsUseCase(requestId: requestId);

    handle(
      result,
      failure: (failure) =>
          emit(BrandOwnerWastAndDamageDetailsFailure(failure)),
      success: (details) =>
          emit(BrandOwnerWastAndDamageDetailsSuccess(details)),
    );
  }

  Future<void> approve({required String requestId}) async {
    final details = _currentDetails();
    if (details == null) return;

    emit(
      BrandOwnerWastAndDamageDetailsActionLoading(
        details,
        BrandOwnerInventoryActionType.approve,
      ),
    );

    final result = await _approveUseCase(requestId: requestId);

    handle(
      result,
      failure: (failure) => emit(
        BrandOwnerWastAndDamageDetailsActionFailure(
          details,
          failure,
          BrandOwnerInventoryActionType.approve,
        ),
      ),
      success: (_) => emit(
        BrandOwnerWastAndDamageDetailsActionSuccess(
          details,
          BrandOwnerInventoryActionType.approve,
        ),
      ),
    );
  }

  Future<void> reject({required String requestId}) async {
    final details = _currentDetails();
    if (details == null) return;

    emit(
      BrandOwnerWastAndDamageDetailsActionLoading(
        details,
        BrandOwnerInventoryActionType.reject,
      ),
    );

    final result = await _rejectUseCase(requestId: requestId);

    handle(
      result,
      failure: (failure) => emit(
        BrandOwnerWastAndDamageDetailsActionFailure(
          details,
          failure,
          BrandOwnerInventoryActionType.reject,
        ),
      ),
      success: (_) => emit(
        BrandOwnerWastAndDamageDetailsActionSuccess(
          details,
          BrandOwnerInventoryActionType.reject,
        ),
      ),
    );
  }

  BrandOwnerWastAndDamageDetailsResponse? _currentDetails() {
    return switch (state) {
      BrandOwnerWastAndDamageDetailsSuccess(:final details) ||
      BrandOwnerWastAndDamageDetailsActionLoading(:final details) ||
      BrandOwnerWastAndDamageDetailsActionSuccess(:final details) ||
      BrandOwnerWastAndDamageDetailsActionFailure(:final details) => details,
      _ => null,
    };
  }
}
