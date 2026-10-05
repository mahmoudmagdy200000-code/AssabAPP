import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../../../../../core/errors/api_failure.dart';
import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../data/model/add_cashier_models/update_cashier_request.dart';
import '../../../data/repository/shift_management_repository_imp.dart';
import '../../../domain/entity/cashier_entity.dart';

part 'cashier_update_state.dart';

class CashierUpdateCubit extends SafeCubit<CashierUpdateState> {
  final ShiftManagementRepositoryImp _repository;

  CashierUpdateCubit(ShiftManagementRepositoryImp repository)
    : _repository = repository,
      super(CashierDetailsInitial());

  Future<void> updateCashier({
    required bool openedFromChangeShiftButton,
    required CashierEntity newCashier,
    required CashierEntity originalCashier,
  }) async {
    emit(CashierUpdateLoading());

    final oldShiftIds =
        originalCashier.workingShifts?.map((s) => s.id).toSet() ?? {};
    final newShiftIds =
        newCashier.workingShifts?.map((s) => s.id).toSet() ?? {};

    final List<String> shiftIdsToSend = oldShiftIds.containsAll(newShiftIds)
        ? []
        : newShiftIds.toList();

    final result = await _repository.updateCashier(
      cashierId: newCashier.id,
      request: UpdateCashierRequest(
        name: newCashier.name,
        email: newCashier.email,
        status: newCashier.status.name,
        shiftIds: shiftIdsToSend,
        storeBranchId: newCashier.branch.id == originalCashier.branch.id
            ? null
            : newCashier.branch.id,
      ),
    );

    handle(
      result,
      success: (_) {
        emit(
          CashierUpdateSuccess(
            openedFromChangeShiftButton: openedFromChangeShiftButton,
            cashier: newCashier,
          ),
        );
      },
      failure: (failure) {
        emit(CashierUpdateFailure(failure));
      },
    );
  }

  Future<void> getCashierDetails({
    bool? openedFromChangeShiftButton,
    required String cashierId,
  }) async {
    emit(CashierDetailsFetchLoading());

    final result = await _repository.getCashierDetails(cashierId: cashierId);

    handle(
      result,
      success: (cashier) {
        emit(
          CashierDetailsFetchSuccess(
            openedFromChangeShiftButton: openedFromChangeShiftButton,
            cashier: cashier,
          ),
        );
      },
      failure: (failure) {
        emit(CashierDetailsFetchFailure(failure));
      },
    );
  }
}
