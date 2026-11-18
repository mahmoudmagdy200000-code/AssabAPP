import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../core/styles/app_colors.dart';
import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/widgets/custom_divider.dart';
import '../../../../../shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import '../../../../../shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/see_details_button_widget.dart';
import '../../../../domain/entities/cashier_my_shift_entity.dart';
import '../../../formatter/cashier_shift_date_formatter.dart';
import '../../../formatter/cashier_shift_time_formatter.dart';
import '../card_label_widget.dart';
import 'pending_start_button_section.dart';

class CashierMyPendingShiftsDefaultCard extends StatelessWidget {
  const CashierMyPendingShiftsDefaultCard({super.key, required this.shift});

  final CashierShiftEntity shift;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsetsGeometry.all(15.w),
        width: 340.w,
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    CashierShiftDateFormatter.format(shift.date),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.s15W600,
                  ),
                ),
                8.horizontalSpace,
                CardLabelWidget(title: context.tr.not_started),
              ],
            ),

            12.verticalSpace,
            CustomDivider(color: context.customColor.border),
            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              firstTitleSvgAsset: AppAssets.clockSvg,
              title: context.tr.startTime,
              value: CashierShiftTimeFormatter.formatForUi(context, shift.startTime),
            ),

            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              title: context.tr.openingBalance,
              value: formatOpeningBalanceDisplay(context, shift.openingBalance),
              firstValueSvgAsset: shift.openingBalance == null
                  ? null
                  : AppAssets.saudiRiyal,
            ),

            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              firstTitleSvgAsset: AppAssets.personSvg,
              title: context.tr.next_cashier,
              value: shift.nextCashier ?? context.tr.no_name,
            ),

            15.verticalSpace,
            CustomDivider(color: context.customColor.border),

            12.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PendingStartButtonSection(
                    shift: shift,
                    isFlexible: true,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: SeeDetailsButtonWidget(
                    shiftId: shift.id,
                    isCashier: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
