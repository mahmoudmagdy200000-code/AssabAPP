import 'package:assab/core/enums/shift_status/shift_handover_status.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../data/mapper/shift/shift_details/handover_status_ui_mapper.dart';
import '../../../ui/widgets/cashier_shifts_management_widgets/cashier_info_container_widget.dart';
import '../../../ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import 'manager_shift_handover_widget_strategy.dart';

class ManagerShiftNotSubmittedHandoverWidget
    extends ManagerShiftHandoverCardStrategy {
  ManagerShiftNotSubmittedHandoverWidget();

  @override
  Widget buildTabContent(BuildContext context) {
    return CashierInfoContainerWidget(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.tr.handover, style: AppStyles.s13W600),

            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(7.w),
              decoration: BoxDecoration(
                color: HandoverStatus.notSubmitted.cardColor,
                borderRadius: BorderRadius.circular(10.r),
              ),

              child: Text(
                HandoverStatus.notSubmitted.label,
                style: AppStyles.s12W500.copyWith(
                  color: HandoverStatus.notSubmitted.textColor,
                ),
              ),
            ),
          ],
        ),

        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handOverAmount,
          firstTitleSvgAsset: AppAssets.cash,
          firstValueSvgAsset: AppAssets.saudiRiyal,
          hasSpaceBetweenTitleAndValue: true,
          value: '-',
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.variance,
          firstTitleSvgAsset: AppAssets.personSvg,
          firstValueSvgAsset: AppAssets.saudiRiyal,
          hasSpaceBetweenTitleAndValue: true,
          value: '-',
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverTo,
          firstTitleSvgAsset: AppAssets.personSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: '-',
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverDate,
          firstTitleSvgAsset: AppAssets.calendar,
          hasSpaceBetweenTitleAndValue: true,
          value: '-',
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverTime,
          firstTitleSvgAsset: AppAssets.clockSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: '-',
        ),
      ],
    );
  }
}
