import 'package:assab/core/enums/shift_status/shift_handover_status.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/handover_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/strategies/manager_shift_Management_screen_strategy/manager_shift_handover_card_strategy/manager_shift_completed_handover_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/strategies/manager_shift_Management_screen_strategy/manager_shift_handover_card_strategy/manager_shift_handover_rejected_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/strategies/manager_shift_Management_screen_strategy/manager_shift_handover_card_strategy/manager_shift_pending_handover_widget.dart';

import 'manager_shift_handover_widget_strategy.dart';
import 'manager_shift_not_submitted_handover_widget.dart';

class ManagerShiftHandoverWidgetStrategyFactory {
  static ManagerShiftHandoverCardStrategy getStrategy({
    required HandoverStatus? handoverStatus,
    required String managerName,
    required HandoverDetailsEntity handover,
    bool showButtons = true,
  }) {
    switch (handoverStatus) {
      case HandoverStatus.pending:
        return ManagerShiftPendingHandoverWidget(
          handover: handover,
          showButtons: showButtons,
          managerName: managerName,
        );
      case HandoverStatus.rejected:
        return ManagerShiftHandoverRejectedWidget(
          handover: handover,
          showButtons: showButtons,
          managerName: managerName,
        );
      case HandoverStatus.accepted:
        return ManagerShiftCompletedHandoverWidget(
          handover: handover,
          showButtons: showButtons,
        );

      case HandoverStatus.notSubmitted:
        return ManagerShiftNotSubmittedHandoverWidget();

      default:
        return ManagerShiftPendingHandoverWidget(
          handover: handover,
          showButtons: showButtons,
          managerName: managerName,
        );
    }
  }
}
