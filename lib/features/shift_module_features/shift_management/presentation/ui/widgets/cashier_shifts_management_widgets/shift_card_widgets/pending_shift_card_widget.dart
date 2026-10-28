import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/shift_status_ui_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/cashier_shifts_management_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../../core/widgets/custom_divider.dart';
import '../../../../logic/cashier/start_cashier_shift_cubit.dart';
import '../../shift_details_widgets/see_details_button_widget.dart';
import '../cashier_start_shift_button.dart';

class PendingShiftCardWidget extends ShiftCardStrategy {
  final ShiftStatus selectedShiftsStatus;

  PendingShiftCardWidget({required this.selectedShiftsStatus});
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
                child: Text(context.tr.not_started, style: AppStyles.s10W400),
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

          buildShiftCardRowWidget(
            context: context,
            firstTitleSvgAsset: AppAssets.personSvg,
            title: context.tr.next_cashier,
            value: shift.nextCashier?.name ?? context.tr.no_name,
          ),

          15.verticalSpace,
          CustomDivider(color: context.customColor.border),

          12.verticalSpace,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isShiftTodayOrBefore(shift.shiftDate))
                BlocListener<StartCashierShiftCubit, StartCashierShiftState>(
                  listener: (context, state) {
                    final cashierShiftsManagementCubit = context
                        .read<CashierShiftsManagementCubit>();
                    if (state is StartCashierShiftSuccess &&
                        !cashierShiftsManagementCubit
                            .state
                            .inProgress
                            .isLoading &&
                        !cashierShiftsManagementCubit.state.pending.isLoading) {
                      // to prevent multiple fetching

                      cashierShiftsManagementCubit.getPendingShifts(
                        loadMore: false,
                      );

                      cashierShiftsManagementCubit.getInProgressShifts(
                        loadMore: false,
                      );
                    }

                    if (state is StartCashierShiftFailure) {
                      AppDialog.showErrorDialog(
                        context: context,
                        failure: state.failure,
                      );
                    }
                  },
                  child: CashierStartShiftButton(
                    shiftId: shift.id,
                    selectedShiftsStatus: selectedShiftsStatus,
                    actorRole: UserTypeService.selectedUserType ?? UserType.branchManager,
                  ),
                )
              else
                Expanded(
                  child: AppButton(
                    padding: EdgeInsets.all(12.w),
                    borderRadius: BorderRadius.circular(12.r),
                    onClick: () async {
                      final result = await NavigationService.I.pushNamed(
                        AppRouteName.reassignShiftWithoutHandoverScreen,
                        arguments: {
                          'shift': shift,
                          'previousCashier': shift.cashier,
                          'nextCashier': shift.nextCashier,
                        },
                      );

                      if (result == true) {
                        context
                            .read<CashierShiftsManagementCubit>()
                            .getPendingShifts();
                      }
                    },
                    text: context.tr.reassign_shift,
                    enabled: true,
                  ),
                ),
              12.horizontalSpace,
              Expanded(child: SeeDetailsButtonWidget(shiftId: shift.id)),
            ],
          ),
        ],
      ),
    );
  }

  bool isShiftTodayOrBefore(String shiftDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final parsedShiftDate = DateFormat('yyyy-MM-dd').parse(shiftDate);

    return !parsedShiftDate.isAfter(today);
  }
}
