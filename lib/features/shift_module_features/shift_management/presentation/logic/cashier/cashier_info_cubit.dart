import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_info_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/working_shift_entity.dart';

import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../data/model/cashier_model.dart';
import '../../../domain/entity/cashier_entity.dart';
import 'cashier_info_state.dart';

class CashierInfoCubit extends SafeCubit<CashierInfoState> {
  CashierInfoCubit()
    : super(
        const CashierInfoState(
          originalCashier: null,
          cashier: null,
          isEditing: false,
        ),
      );

  void initCashier(CashierEntity cashier) {
    emit(
      CashierInfoState(
        originalCashier: cashier,
        cashier: cashier,
        isEditing: false,
      ),
    );
  }

  void enableEdit() {
    emit(state.copyWith(originalCashier: state.cashier, isEditing: true));
  }

  void cancelEdit() {
    emit(state.copyWith(cashier: state.originalCashier, isEditing: false));
  }

  void updateBranch(String branchName, String branchId) {
    emit(
      state.copyWith(
        cashier: state.cashier?.copyWith(
          branch: BranchEntity(id: branchId, name: branchName),
        ),
      ),
    );
  }

  void updateName(String value) {
    emit(state.copyWith(cashier: state.cashier?.copyWith(name: value)));
  }

  void updateEmail(String value) {
    emit(state.copyWith(cashier: state.cashier?.copyWith(email: value)));
  }

  void updateShift(ShiftInfoDetailsEntity shift) {
    emit(
      state.copyWith(
        cashier: state.cashier?.copyWith(
          workingShifts: [
            WorkingShiftEntity(
              id: shift.id,
              name: shift.name,
              startTime: shift.startTime,
              endTime: shift.endTime,
            ),
          ],
        ),
      ),
    );
  }

  void updateStatus(CashierStatus status) {
    emit(state.copyWith(cashier: state.cashier?.copyWith(status: status)));
  }

  bool hasChanges({
    required String email,
    required String name,
    required String branchName,
    required String shiftName,
    required CashierStatus status,
  }) {
    return (state.originalCashier?.email != email) ||
        (state.originalCashier?.name != name) ||
        state.originalCashier?.status != status ||
        state.originalCashier?.branch.name != branchName ||
        ((state.cashier?.workingShifts != null &&
                state.cashier!.workingShifts!.isNotEmpty) &&
            (state.originalCashier?.workingShifts?[0].name != shiftName));
  }
}
