import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/shift_status_ui_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/custom_divider.dart';
import '../../shift_details_widgets/see_details_button_widget.dart';

class CompletedShiftCardWidget extends ShiftCardStrategy {
  @override
  Widget buildCard(BuildContext context, ShiftEntity shift) {
    return Container(
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
              Text(shift.shiftDateFormatted, style: AppStyles.s15W600),
              Container(
                padding: EdgeInsetsDirectional.only(
                  start: 10.w,
                  end: 10.w,
                  top: 5.h,
                  bottom: 5.h,
                ),
                decoration: BoxDecoration(
                  color: shift.status.cardColor(context),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  context.tr.completed_name,
                  style: AppStyles.s11W500.copyWith(
                    color: shift.status.textColor(context),
                  ),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          CustomDivider(color: context.customColor.border),
          12.verticalSpace,

          buildShiftCardRowWidget(
            context: context,
            title: context.tr.start_time,
            value: shift.shiftTimeDetails.formattedStartTime,
            firstTitleSvgAsset: AppAssets.clockSvg,
            hasTwoRows: true,
            secondTitle: context.tr.end,
            secondValue: shift.shiftTimeDetails.formattedEndTime,
          ),

          12.verticalSpace,

          buildShiftCardRowWidget(
            context: context,
            firstTitleSvgAsset: AppAssets.cash,
            title: context.tr.closing_balance,
            value: shift.closingBalance.toString(),
            firstValueSvgAsset: AppAssets.saudiRiyal,
            hasTwoRows: true,
            secondTitle: context.tr.variance,
            secondValue: (shift.variance ?? 0).toString(),
            secondValueSvgAsset: AppAssets.saudiRiyal,
          ),
          12.verticalSpace,

          buildShiftCardRowWidget(
            context: context,
            firstTitleSvgAsset: AppAssets.personSvg,
            title: context.tr.assigned_to,
            value: shift.cashier.name,
          ),

          12.verticalSpace,

          buildShiftCardRowWidget(
            context: context,
            firstTitleSvgAsset: AppAssets.personSvg,
            title: context.tr.next_cashier,
            value: shift.nextCashier?.name ?? context.tr.no_name,
          ),

          15.verticalSpace,
          CustomDivider(color: context.customColor.border),

          12.verticalSpace,

          SeeDetailsButtonWidget(shiftId: shift.id),
        ],
      ),
    );
  }
}
