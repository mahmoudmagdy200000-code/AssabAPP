import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/end_shift_models/cashier_breakdown_request_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/end_shift_models/manager_end_shift_request_model.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/cashier_breakdown_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/enums/manager_shift/end_shift_handover_timing.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../../data/model/manager_shift_management_models/end_shift_models/update_manager_handover_request_model.dart';
import '../../../../data/repository/shift_management_repository_imp.dart';
import '../../../../domain/entity/manager_shift/end_shift_response_entites/manager_shift_end_data_entity.dart';

part 'end_manager_shift_state.dart';

@injectable
class EndAndUpdateManagerShiftCubit
    extends SafeCubit<EndAndUpdateManagerShiftState> {
  EndAndUpdateManagerShiftCubit(this._repo) : super(EndManagerShiftInitial());

  final ShiftManagementRepositoryImp _repo;

  late HandoverTiming handoverTiming;

  Future<void> endManagerShift({
    required List<CashierBreakdownEntity> cashierBreakdown,
    required double totalSales,
    required double cashCollected,
    required double cardPayments,
    required double aggregatorPayments,
  }) async {
    // Guard against double submission while network request is in-flight
    if (state is EndManagerShiftButtonLoading) return;

    emit(EndManagerShiftButtonLoading());

    final result = await _repo.endManagerShift(
      request: EndManagerShiftRequestModel(
        handoverTiming: handoverTiming,
        totalSales: totalSales,
        cashCollected: cashCollected,
        cardPayments: cardPayments,
        aggregatorPayments: aggregatorPayments,
        cashierBreakdown: cashierBreakdown
            .map(
              (e) => CashierBreakdownRequestModel(
                cashierId: e.cashierId,
                cashCollected: e.cashCollected,
                cardPayments: e.cardPayments,
                deliveryAppPayments: e.deliveryAppPayments,
                sales: e.cashierTotal,
              ),
            )
            .toList(),
      ),
    );

    handle(
      result,
      failure: (failure) => emit(EndManagerShiftFailure(failure)),
      success: (managerShift) =>
          emit(EndManagerShiftSuccess(managerShift: managerShift)),
    );
  }

  Future<void> updateManagerHandoverShift({
    required List<CashierBreakdownEntity> cashierBreakdown,
  }) async {
    // Guard against double submission while network request is in-flight
    if (state is EndManagerShiftButtonLoading) return;

    emit(EndManagerShiftButtonLoading());

    final result = await _repo.updateManagerHandoverShift(
      request: UpdateManagerHandoverRequestModel(
        cashierBreakdown: cashierBreakdown
            .map(
              (e) => CashierBreakdownRequestModel(
                cashierId: e.cashierId,
                cashCollected: e.cashCollected,
                cardPayments: e.cardPayments,
                deliveryAppPayments: e.deliveryAppPayments,
                sales: e.cashierTotal,
              ),
            )
            .toList(),
      ),
    );

    handle(
      result,
      failure: (failure) => emit(EndManagerShiftFailure(failure)),
      success: (managerShift) => emit(
        EndManagerShiftSuccess(
          managerShift: ManagerShiftEndDataEntity(
            finalHandover: managerShift.shift.finalHandover,
            dailyTotals: managerShift.dailyTotals,
          ),
        ),
      ),
    );
  }
}