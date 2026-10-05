import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/tabs_widgets/reassigned_to_me_shift_details_tab_widget.dart';

import 'all_details_widget.dart';
import 'sales_and_handover_tab_widget.dart';
import 'shift_details_tab_widget.dart';
import 'shift_tab_widget_strategy.dart';

class ShiftTabStrategyFactory {
  static ShiftTabStrategy getStrategy(
    int index, {
    bool isReassignedToMe = false,
  }) {
    switch (index) {
      case 0:
        return AllDetailsTabWidget();
      case 1:
        if (isReassignedToMe) {
          return ReassignedToMeShiftDetailsTabWidget();
        }
        return ShiftDetailsTabWidget();
      case 2:
        return SalesAndHandoverTabWidget(allowScroll: true);

      default:
        return AllDetailsTabWidget();
    }
  }
}
