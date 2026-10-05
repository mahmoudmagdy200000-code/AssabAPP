import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/manager_see_details_button_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../../data/mapper/shift/shift_details/handover_status_ui_mapper.dart';
import '../../../../domain/entity/manager_shift/current_shift/handover_details_entity.dart';
import '../../../ui/widgets/cashier_shifts_management_widgets/cashier_info_container_widget.dart';
import '../../../ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import 'manager_shift_handover_widget_strategy.dart';

class ManagerShiftCompletedHandoverWidget
    extends ManagerShiftHandoverCardStrategy {
  final HandoverDetailsEntity handover;
  final bool showButtons;
  ManagerShiftCompletedHandoverWidget({
    required this.handover,
    this.showButtons = true,
  });

  @override
  Widget buildTabContent(BuildContext context) {
    return CashierInfoContainerWidget(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.tr.handover, style: AppStyles.s13W600),

            Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: EdgeInsets.all(3.w),
              child: Text(
                handover.handoverStatus.label,
                style: AppStyles.s12W500.copyWith(
                  color: handover.handoverStatus.textColor,
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
          value: handover.handoverAmount.toStringAsFixed(2),
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.variance,
          firstTitleSvgAsset: AppAssets.personSvg,
          firstValueSvgAsset: AppAssets.saudiRiyal,
          hasSpaceBetweenTitleAndValue: true,
          value: handover.varianceAmount.toStringAsFixed(2),
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverTo,
          firstTitleSvgAsset: AppAssets.personSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: handover.handoverTo ?? context.tr.no_name,
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverDate,
          firstTitleSvgAsset: AppAssets.calendar,
          hasSpaceBetweenTitleAndValue: true,
          value: handover.formattedHandoverDate ?? context.tr.no_name,
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverTime,
          firstTitleSvgAsset: AppAssets.clockSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: handover.formattedHandoverTime ?? '00:00',
        ),

        1.verticalSpace,
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          decoration: BoxDecoration(color: handover.handoverStatus.cardColor),
          child: Text(
            context.tr.handoverApprovedByYou(
              handover.formattedHandoverDateTime,
            ),
            textAlign: TextAlign.center,
            style: AppStyles.s13W500.copyWith(
              color: handover.handoverStatus.textColor,
            ),
          ),
        ),

        const CustomDivider(),

        if (showButtons) ManagerSeeDetailsButtonWidget(handover: handover),
      ],
    );
  }
}
