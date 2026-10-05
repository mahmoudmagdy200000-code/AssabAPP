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

class CashierMyCompletedShiftsHandoverDetectedCard extends StatelessWidget {
  const CashierMyCompletedShiftsHandoverDetectedCard({
    super.key,
    required this.shift,
  });

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
                Text(
                  CashierShiftDateFormatter.format(shift.date),
                  style: AppStyles.s15W600,
                ),
                CardLabelWidget(
                  title: context.tr.completed,
                  textColor: AppColors.lightGreen,
                ),
              ],
            ),

            12.verticalSpace,
            CustomDivider(color: context.customColor.border),
            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              firstTitleSvgAsset: AppAssets.clockSvg,
              title: context.tr.startTime,
              hasTwoRows: true,
              value: CashierShiftTimeFormatter.format(shift.startTime),
              secondTitle: context.tr.end_time,
              secondValue: CashierShiftTimeFormatter.format(shift.endTime),
            ),

            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              title: context.tr.closing_balance,
              firstTitleSvgAsset: AppAssets.cash,
              value: (shift.closingBalance ?? 0).toString(),
              firstValueSvgAsset: AppAssets.saudiRiyal,
              hasTwoRows: true,
              secondTitle: context.tr.variance,
              secondValue: (shift.variance ?? 0).toString(),
              secondValueSvgAsset: AppAssets.saudiRiyal,
            ),

            12.verticalSpace,
            CustomDivider(color: context.customColor.border),
            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              firstTitleSvgAsset: AppAssets.personSvg,
              title: context.tr.handoverTo,
              value: shift.handoverTo?.name ?? context.tr.no_name,
            ),

            15.verticalSpace,
            CustomDivider(color: context.customColor.border),

            12.verticalSpace,

            SeeDetailsButtonWidget(shiftId: shift.id),
          ],
        ),
      ),
    );
  }
}
