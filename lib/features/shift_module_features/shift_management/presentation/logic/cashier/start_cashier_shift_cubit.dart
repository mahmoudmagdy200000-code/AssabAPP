import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/shift_management_repository_imp.dart';

part 'start_cashier_shift_state.dart';

@injectable
class StartCashierShiftCubit extends SafeCubit<StartCashierShiftState> {
  final ShiftManagementRepositoryImp _repository;

  StartCashierShiftCubit(this._repository) : super(StartCashierShiftInitial());

  /// Cashier starts their own assigned shift:
  /// POST /api/v1/cashier/shifts/{shift}/start
  Future<void> startCashierShift(String shiftId) async {
    emit(StartCashierShiftLoading(shiftId));

    final result = await _repository.startCashierShift(shiftId);

    handle(
      result,
      failure: (f) => emit(StartCashierShiftFailure(f)),
      success: (shift) => emit(StartCashierShiftSuccess()),
    );
  }

  /// Branch Manager starts an assigned cashier's shift:
  /// POST /api/v1/branch-manager/shifts/start-by-manager/{shiftId}
  Future<void> startShiftByManager(String shiftId) async {
    emit(StartCashierShiftLoading(shiftId));

    final result = await _repository.startShiftByManager(shiftId);

    handle(
      result,
      failure: (f) => emit(StartCashierShiftFailure(f)),
      success: (shift) => emit(StartCashierShiftSuccess()),
    );
  }

  /// Dispatches the start shift request according to the authenticated actor's validated role
  /// or explicit command context, preventing role inference solely based on widget placement.
  Future<void> startShift({
    required String shiftId,
    UserType? actorRole,
  }) async {
    final effectiveRole = actorRole ??
        UserTypeService.selectedUserType ??
        UserTypeService.getSavedUserType();

    if (effectiveRole == UserType.branchManager) {
      await startShiftByManager(shiftId);
    } else {
      await startCashierShift(shiftId);
    }
  }
}