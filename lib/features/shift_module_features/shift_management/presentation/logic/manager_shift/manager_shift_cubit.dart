import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/manager_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/progress_entity.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/errors/api_failure.dart';
import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/entity/manager_shift/cashier_handover_details_entity/cashier_handover_details_entity.dart';

part 'manager_shift_state.dart';

@injectable
class ManagerShiftCubit extends SafeCubit<ManagerShiftState> {
  ManagerShiftCubit(this._repositoryImp) : super(ManagerShiftInitial());

  final ShiftManagementRepositoryImp _repositoryImp;

  late CurrentShiftEntity managerShift;

  Future<void> getCurrentShift() async {
    emit(ManagerShiftLoading());
    final result = await _repositoryImp.getCurrentShift();
    handle(
      result,
      failure: (failure) => emit(ManagerShiftFailure(failure)),
      success: (currentShift) {
        managerShift = currentShift;
        emit(
          ManagerShiftLoaded(
            managerShift: managerShift.shift,
            shiftProgress: managerShift.progress,
          ),
        );
      },
    );
  }

  Future<void> startManagerShift() async {
    emit(ManagerShiftButtonLoading());
    final result = await _repositoryImp.startManagerShift();

    handle(
      result,
      failure: (failure) => emit(ManagerShiftFailure(failure)),
      success: (success) => getCurrentShift(),
    );
  }

  Future<void> getCashierHandoverDetails(String handoverId) async {
    emit(CashierHandoverDetailsLoading());
    final result = await _repositoryImp.getHandoverDetails(
      handoverId: handoverId,
    );

    handle(
      result,
      failure: (failure) => emit(CashierHandoverDetailsLoadingFailure(failure)),
      success: (handoverDetails) =>
          emit(CashierHandoverDetailsLoaded(handoverDetails: handoverDetails)),
    );
  }
}
