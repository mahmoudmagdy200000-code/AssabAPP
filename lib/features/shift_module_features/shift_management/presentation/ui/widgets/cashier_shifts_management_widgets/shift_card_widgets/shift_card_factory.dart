import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/completed_shift_card_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/pending_shift_card_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/reassigned_shift_card_widget.dart';

import '../../../../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../../../../../core/enums/shift_status/shift_status_type.dart';
import 'in_progress_shift_card_widget.dart';
import 'shift_card.dart';

class ShiftCardFactory {
  static ShiftCardStrategy getStrategy(
    ShiftStatusType status,
    ShiftStatus selectedShiftsStatus,
  ) {
    switch (status) {
      case ShiftStatusType.pending:
        return PendingShiftCardWidget(
          selectedShiftsStatus: selectedShiftsStatus,
        );
      case ShiftStatusType.completed:
        return CompletedShiftCardWidget();
      case ShiftStatusType.reassigned:
        return ReassignedShiftCardWidget(
          selectedShiftsStatus: selectedShiftsStatus,
        );
      case ShiftStatusType.inProgress:
        return InProgressShiftCardWidget();
      default:
        return PendingShiftCardWidget(
          selectedShiftsStatus: selectedShiftsStatus,
        ); // fallback
    }
  }
}
