import 'package:flutter/material.dart';

import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../domain/entity/manager_shift/current_shift/handover_details_entity.dart';
import 'handover_received_widgets/empty_or_not_submitted_handover_widget.dart';
import 'handover_received_widgets/handover_received_widget.dart';

class ManagerEndShiftHandoffsReceivedWidget extends StatelessWidget {
  const ManagerEndShiftHandoffsReceivedWidget({
    super.key,
    required this.handovers,
    required this.managerName,
  });

  final List<HandoverDetailsEntity> handovers;
  final String managerName;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AppPaddingWidget(
        right: 5.w,
        left: 5.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr.finalHandoverSummary, style: AppStyles.s20W500),
            2.verticalSpace,
            Text(
              context.tr.finalHandoverSummaryDesc,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            15.verticalSpace,

            handovers.isEmpty
                ? const EmptyAndNotSubmittedHandoverWidget()
                : HandoversReceivedWidget(
                    handovers: handovers,
                    managerName: managerName,
                  ),
          ],
        ),
      ),
    );
  }
}
