import 'package:assab/core/errors/api_failure.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/shift_management_repository_imp.dart';

part 'start_cashier_shift_state.dart';

@injectable
class StartCashierShiftCubit extends SafeCubit<StartCashierShiftState> {
  final ShiftManagementRepositoryImp _repository;

  StartCashierShiftCubit(this._repository) : super(StartCashierShiftInitial());

  Future<void> startCashierShift(String shiftId) async {
    emit(StartCashierShiftLoading(shiftId));

    final result = await _repository.startCashierShift(shiftId);

    handle(
      result,
      failure: (f) => emit(StartCashierShiftFailure(f)),
      success: (shift) => emit(StartCashierShiftSuccess()),
    );
  }
}
