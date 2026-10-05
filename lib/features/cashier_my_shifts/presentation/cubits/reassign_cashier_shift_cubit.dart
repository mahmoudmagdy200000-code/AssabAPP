import 'package:assab/core/errors/api_failure.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../data/repository/cashier_my_shifts_repo.dart';

part 'reassign_cashier_shift_state.dart';

@injectable
class ReassignedShiftActionsCubit
    extends SafeCubit<ReassignedShiftActionsState> {
  final CashierMyShiftsRepo _repo;

  ReassignedShiftActionsCubit(this._repo) : super(ReassignShiftActionInitial());

  Future<void> acceptReassignedCashierShift(String shiftId) async {
    emit(ReassignShiftActionLoading());

    final result = await _repo.acceptReassignedCashierShift(shiftId);

    handle(
      result,
      failure: (f) => emit(ReassignShiftActionFailure(f)),
      success: (shift) => emit(ReassignShiftActionSuccess()),
    );
  }
}
