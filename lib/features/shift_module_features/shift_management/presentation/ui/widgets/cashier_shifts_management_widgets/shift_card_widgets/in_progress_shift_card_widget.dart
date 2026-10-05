import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/shift_status_ui_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/cashier_shifts_management_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/end_shift_options_bottom_sheet.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../../core/widgets/custom_divider.dart';
import '../../shift_details_widgets/see_details_button_widget.dart';

class InProgressShiftCardWidget extends ShiftCardStrategy {
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
                  context.tr.in_progress_name,
                  style: AppStyles.s10W400.copyWith(
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
            title: context.tr.openingBalance,
            value: shift.openingBalance == 0
                ? context.tr.not_recorded_yet
                : shift.openingBalance.toString(),
          ),
          12.verticalSpace,

          buildShiftCardRowWidget(
            context: context,
            firstTitleSvgAsset: AppAssets.personSvg,
            title: context.tr.assigned_to,
            value: shift.cashier.name,
          ),

          12.verticalSpace,

          if (shift.nextCashier != null)
            buildShiftCardRowWidget(
              context: context,
              firstTitleSvgAsset: AppAssets.personSvg,
              title: context.tr.next_cashier,
              value: shift.nextCashier!.name,
            ),

          15.verticalSpace,
          CustomDivider(color: context.customColor.border),

          12.verticalSpace,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // BlocProvider(create: (context) => EndShiftOptionCubit(),
              // child:
              AppButton(
                width: 150.w,
                padding: EdgeInsets.all(12.w),
                borderRadius: BorderRadius.circular(12.r),
                background: shift.hasEnded
                    ? AppColors.lightGreen
                    : AppColors.red,
                onClick: () {
                  AppBottomSheet.showModal(
                    context,
                    isScrollControlled: true,
                    (sheetContext) => EndShiftOptionsBottomSheet(
                      hasEnded: shift.hasEnded,
                      shift: shift,
                      onSuccessEndedOrReassigned: () {
                        context
                            .read<CashierShiftsManagementCubit>()
                            .getInProgressShifts();
                        context
                            .read<CashierShiftsManagementCubit>()
                            .getCompletedShifts();
                      },
                    ),
                  );
                },
                text: context.tr.end_shift,
                enabled: true,
              ),

              // ),
              SeeDetailsButtonWidget(shiftId: shift.id, width: 150.w),
            ],
          ),
        ],
      ),
    );
  }
}

class EndShiftOptionWidget extends StatelessWidget {
  final bool isSelected;
  final String assetName;
  final String title;
  final String desc;
  final VoidCallback onTap;

  const EndShiftOptionWidget({
    super.key,
    required this.isSelected,
    required this.assetName,
    required this.title,
    required this.desc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? context.theme.primaryColor
                : context.customColor.border,
            width: 1.w,
          ),
        ),
        child: Column(
          children: [
            AppSvg(assetName: assetName, width: 20.w, height: 25.h),
            10.verticalSpace,
            Text(title, style: AppStyles.s15W600),
            10.verticalSpace,
            Text(
              desc,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
