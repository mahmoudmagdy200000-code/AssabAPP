import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/strategies/manager_shift_Management_screen_strategy/manager_shift_main_screen_tabs_strategy/manager_main_screen_all_tab_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/strategies/manager_shift_Management_screen_strategy/manager_shift_main_screen_tabs_strategy/manager_main_screen_final_handover_tab_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/strategies/manager_shift_Management_screen_strategy/manager_shift_main_screen_tabs_strategy/manager_main_screen_handoffs_received_tab_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/strategies/manager_shift_Management_screen_strategy/manager_shift_main_screen_tabs_strategy/manager_main_screen_shift_details_tab_widget.dart';

import 'manager_main_screen_tab_strategy.dart';

class ManagerShiftMainScreenTabsStrategyFactory {
  static ManagerMainScreenTabStrategy getStrategy({
    required int index,
    required CurrentShiftEntity currentManagerShift,
  }) {
    switch (index) {
      case 0:
        return ManagerMainScreenAllTabWidget(managerShift: currentManagerShift);
      case 1:
        return ManagerMainScreenShiftDetailsTabWidget(
          managerShift: currentManagerShift.shift,
          shiftProgress: currentManagerShift.progress,
        );
      case 2:
        return ManagerMainScreenHandoffsReceivedTabWidget(
          managerShift: currentManagerShift,
        );
      case 3:
        return ManagerMainScreenFinalHandoverTabWidget(
          currentManagerShift: currentManagerShift,
          shiftStatus: currentManagerShift.shift.status,
          shiftDate: currentManagerShift.shift.shiftDate,
        );

      default:
        return ManagerMainScreenAllTabWidget(managerShift: currentManagerShift);
    }
  }
}
