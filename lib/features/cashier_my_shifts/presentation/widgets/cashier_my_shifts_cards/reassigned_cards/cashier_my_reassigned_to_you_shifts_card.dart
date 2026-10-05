import 'package:assab/features/cashier_my_shifts/presentation/cubits/reassign_cashier_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../core/styles/app_colors.dart';
import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/utils/app_dialog.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_button_loading.dart';
import '../../../../../../core/widgets/custom_divider.dart';
import '../../../../../shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import '../../../../../shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/see_details_button_widget.dart';
import '../../../../domain/entities/cashier_my_shift_entity.dart';
import '../../../cubits/cashier_my_shifts_cubit.dart';
import '../../../formatter/cashier_shift_date_formatter.dart';
import '../../../formatter/cashier_shift_time_formatter.dart';
import '../card_label_widget.dart';

class CashierMyReassignedToYouShiftsCard extends StatelessWidget {
  const CashierMyReassignedToYouShiftsCard({super.key, required this.shift});

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
                  title: context.tr.reassigned_to_u,
                  textColor: AppColors.dark2Yellow,
                ),
              ],
            ),

            12.verticalSpace,
            CustomDivider(color: context.customColor.border),
            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              firstTitleSvgAsset: AppAssets.personSvg,
              title: context.tr.reassigned_from,
              value: shift.reassignedFrom?.name ?? context.tr.no_name,
            ),

            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              firstTitleSvgAsset: AppAssets.personSvg,
              title: context.tr.reassigned_by,
              value: shift.reassignedBy?.name ?? context.tr.no_name,
            ),

            12.verticalSpace,
            CustomDivider(color: context.customColor.border),
            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              firstTitleSvgAsset: AppAssets.cash,
              title: context.tr.cash_given,
              value: (shift.cashGiven ?? 0).toString(),
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
              firstTitleSvgAsset: AppAssets.clockSvg,
              title: context.tr.startTime,
              value: CashierShiftTimeFormatter.format(shift.startTime),
            ),

            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              firstTitleSvgAsset: AppAssets.clockSvg,
              title: context.tr.end_time,
              value: CashierShiftTimeFormatter.format(shift.endTime),
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
              children: [
                BlocConsumer<
                  ReassignedShiftActionsCubit,
                  ReassignedShiftActionsState
                >(
                  listener: (context, state) {
                    if (state is ReassignShiftActionSuccess) {
                      context
                          .read<CashierMyShiftsCubit>()
                          .getReassignedShifts();
                    } else if (state is ReassignShiftActionFailure) {
                      AppDialog.showErrorDialog(
                        context: context,
                        failure: state.failure,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ReassignShiftActionLoading) {
                      return const Expanded(child: AppButtonLoading());
                    }
                    return Expanded(
                      child: AppButton(
                        padding: EdgeInsets.all(15.w),
                        borderRadius: BorderRadius.circular(12.r),
                        onClick: () {
                          context
                              .read<ReassignedShiftActionsCubit>()
                              .acceptReassignedCashierShift(shift.id);
                        },
                        text: context.tr.acceptShift,
                        enabled: true,
                      ),
                    );
                  },
                ),

                12.horizontalSpace,
                Expanded(child: SeeDetailsButtonWidget(shiftId: shift.id)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
