import 'package:assab/features/shift_module_features/shift_management/domain/entity/cashier_entity.dart';

import '../../../../../../core/helpers/safe_cubit.dart';
import 'choose_employee_state.dart';

class ChooseEmployeeCubit extends SafeCubit<ChooseEmployeeState> {
  ChooseEmployeeCubit() : super(const ChooseEmployeeState());

  void selectEmployee(CashierEntity cashier) {
    emit(
      state.copyWith(
        selectedEmployees: {
          ...state.selectedEmployees,
          cashier: !(state.selectedEmployees[cashier] ?? false),
        },
      ),
    );
  }

  void removeEmployee(CashierEntity cashier) {
    final updatedSelection = Map<CashierEntity, bool>.from(
      state.selectedEmployees,
    )..remove(cashier);

    emit(state.copyWith(selectedEmployees: updatedSelection));
  }

  void clearSelection() {
    emit(state.copyWith(selectedEmployees: {}));
  }
}
