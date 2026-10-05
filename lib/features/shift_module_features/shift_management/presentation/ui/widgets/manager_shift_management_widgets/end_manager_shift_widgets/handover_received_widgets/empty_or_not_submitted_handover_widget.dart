import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/end_manager_shift_widgets/handover_received_widgets/pending_or_rejected_or_not_submitted_handover_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../core/styles/app_styles.dart';
import '../../../../../strategies/manager_shift_Management_screen_strategy/manager_shift_handover_card_strategy/manager_shift_not_submitted_handover_widget.dart';

class EmptyAndNotSubmittedHandoverWidget extends StatelessWidget {
  const EmptyAndNotSubmittedHandoverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PendingOrRejectedOrNotSubmittedHandoverNoteWidget(
          title: context.tr.cashierHandoffNotSubmitted,
          widgetsUnderTheMainTitle: [
            Text(
              context.tr.cashierHandoffNotSubmittedDesc,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ],
          height: 85.h,
        ),
        10.verticalSpace,

        ManagerShiftNotSubmittedHandoverWidget().buildTabContent(context),
      ],
    );
  }
}
