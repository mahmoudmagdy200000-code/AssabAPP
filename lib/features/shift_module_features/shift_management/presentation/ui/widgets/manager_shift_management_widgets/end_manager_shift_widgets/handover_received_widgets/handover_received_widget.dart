import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/end_manager_shift_widgets/handover_received_widgets/pending_or_rejected_or_not_submitted_handover_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../core/enums/shift_status/shift_handover_status.dart';
import '../../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../domain/entity/manager_shift/current_shift/handover_details_entity.dart';
import '../../../../../strategies/manager_shift_Management_screen_strategy/manager_shift_handover_card_strategy/manager_shift_handover_card_strategy_factory.dart';

class HandoversReceivedWidget extends StatelessWidget {
  const HandoversReceivedWidget({
    super.key,
    required this.handovers,
    required this.managerName,
  });

  final String managerName;
  final List<HandoverDetailsEntity> handovers;

  @override
  Widget build(BuildContext context) {
    final hasRejectedOrPending = handovers.any(
      (handover) =>
          handover.handoverStatus == HandoverStatus.rejected ||
          handover.handoverStatus == HandoverStatus.pending,
    );

    return Column(
      children: [
        if (hasRejectedOrPending)
          PendingOrRejectedOrNotSubmittedHandoverNoteWidget(
            title: context.tr.handoffNotApproved,
            widgetsUnderTheMainTitle: [
              Text(
                context.tr.uHaventApprovedTheFinalCashierHandOver,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              7.verticalSpace,
              Text(
                context.tr.pleaseReturnToHandoffListToApprove,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
            height: 100.h,
          ),

        ListView.builder(
          itemCount: handovers.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            // strategy = ManagerShiftHandoverWidgetStrategyFactory.getStrategy(handoverStatus: widget.handovers[index].handoverStatus, handover: widget.handovers[index], showButtons: false);
            return Column(
              children: [
                ManagerShiftHandoverWidgetStrategyFactory.getStrategy(
                  handoverStatus: handovers[index].handoverStatus,
                  handover: handovers[index],
                  managerName: managerName,
                  showButtons: false,
                ).buildTabContent(context),
                10.verticalSpace,
              ],
            );
          },
        ),
      ],
    );
  }
}
