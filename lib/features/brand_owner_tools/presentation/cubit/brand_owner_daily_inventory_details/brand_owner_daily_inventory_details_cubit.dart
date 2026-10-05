import 'package:injectable/injectable.dart';

import '../../../../../core/enums/brand_owner_inventory_action_type.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/brand_owner_daily_inventory_details_response.dart';
import '../../../domain/use_cases/approve_brand_owner_daily_inventory_use_case.dart';
import '../../../domain/use_cases/get_brand_owner_daily_inventory_details_use_case.dart';
import '../../../domain/use_cases/reject_brand_owner_daily_inventory_use_case.dart';
import 'brand_owner_daily_inventory_details_state.dart';

@injectable
class BrandOwnerDailyInventoryDetailsCubit
    extends SafeCubit<BrandOwnerDailyInventoryDetailsState> {
  final GetBrandOwnerDailyInventoryDetailsUseCase _getDetailsUseCase;
  final ApproveBrandOwnerDailyInventoryUseCase _approveUseCase;
  final RejectBrandOwnerDailyInventoryUseCase _rejectUseCase;

  BrandOwnerDailyInventoryDetailsCubit(
    this._getDetailsUseCase,
    this._approveUseCase,
    this._rejectUseCase,
  ) : super(const BrandOwnerDailyInventoryDetailsInitial());

  Future<void> load({required String requestId}) async {
    emit(const BrandOwnerDailyInventoryDetailsLoading());

    final result = await _getDetailsUseCase(requestId: requestId);

    handle(
      result,
      failure: (failure) =>
          emit(BrandOwnerDailyInventoryDetailsFailure(failure)),
      success: (details) =>
          emit(BrandOwnerDailyInventoryDetailsSuccess(details)),
    );
  }

  Future<void> approve({required String requestId}) async {
    final details = _currentDetails();
    if (details == null) return;

    emit(
      BrandOwnerDailyInventoryDetailsActionLoading(
        details,
        BrandOwnerInventoryActionType.approve,
      ),
    );

    final result = await _approveUseCase(requestId: requestId);

    handle(
      result,
      failure: (failure) => emit(
        BrandOwnerDailyInventoryDetailsActionFailure(
          details,
          failure,
          BrandOwnerInventoryActionType.approve,
        ),
      ),
      success: (_) => emit(
        BrandOwnerDailyInventoryDetailsActionSuccess(
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
      BrandOwnerDailyInventoryDetailsActionLoading(
        details,
        BrandOwnerInventoryActionType.reject,
      ),
    );

    final result = await _rejectUseCase(requestId: requestId);

    handle(
      result,
      failure: (failure) => emit(
        BrandOwnerDailyInventoryDetailsActionFailure(
          details,
          failure,
          BrandOwnerInventoryActionType.reject,
        ),
      ),
      success: (_) => emit(
        BrandOwnerDailyInventoryDetailsActionSuccess(
          details,
          BrandOwnerInventoryActionType.reject,
        ),
      ),
    );
  }

  BrandOwnerDailyInventoryDetailsResponse? _currentDetails() {
    return switch (state) {
      BrandOwnerDailyInventoryDetailsSuccess(:final details) ||
      BrandOwnerDailyInventoryDetailsActionLoading(:final details) ||
      BrandOwnerDailyInventoryDetailsActionSuccess(:final details) ||
      BrandOwnerDailyInventoryDetailsActionFailure(:final details) => details,
      _ => null,
    };
  }
}
