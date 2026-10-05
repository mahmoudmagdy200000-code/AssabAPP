import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/enums/manager_shift/end_shift_handover_timing.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/end_manager_shift/end_manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/end_manager_shift_widgets/set_workday_widgets/set_to_business_date_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../../core/widgets/custom_divider.dart';

class ManagerEndShiftSetWorkdayWidget extends StatelessWidget {
  const ManagerEndShiftSetWorkdayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dateTimeFormatter = DateFormat('dd/MMM/yyyy - hh:mm a');
    final dateFormatter = DateFormat('dd/MMM/yyyy');

    final now = DateTime.now();
    final formattedNow = dateTimeFormatter.format(now);

    final todayDate = dateFormatter.format(DateTime.now());

    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayDate = dateFormatter.format(yesterday);

    return SingleChildScrollView(
      child: AppPaddingWidget(
        right: 5.w,
        left: 5.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr.workDayManagement, style: AppStyles.s20W500),
            2.verticalSpace,
            Text(
              context.tr.defineWhichDayYourBranchDataBelongsTo,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),

            15.verticalSpace,
            const CustomDivider(),
            15.verticalSpace,
            Container(
              width: double.infinity,
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 30.w,
                vertical: 25.h,
              ),
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: context.customColor.border,
                  width: 1.w,
                ),
              ),
              child: Column(
                children: [
                  Text(context.tr.currentTimeSummary, style: AppStyles.s15W500),

                  Text(
                    formattedNow,
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),

                  10.verticalSpace,

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gray.withAlpha(10),
                      borderRadius: BorderRadius.circular(20.r),
                    ),

                    child: BlocBuilder<ChooseItemCubit, ChooseItemState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            SetToBusinessDateSelectionWidget(
                              subtitle: context.tr.todayWithDate(todayDate),
                              isSelected: state.selectedIndex == 0,
                              onTap: () {
                                context.read<ChooseItemCubit>().selectItem(0);
                                context
                                        .read<EndAndUpdateManagerShiftCubit>()
                                        .handoverTiming =
                                    HandoverTiming.today;
                                context.read<ValidationCubit>().validateField(
                                  'handoverTiming',
                                  true,
                                );
                              },
                            ),

                            10.verticalSpace,
                            SetToBusinessDateSelectionWidget(
                              subtitle: context.tr.yesterdayWithDate(
                                yesterdayDate,
                              ),
                              isSelected: state.selectedIndex == 1,
                              onTap: () {
                                context.read<ChooseItemCubit>().selectItem(1);
                                context
                                        .read<EndAndUpdateManagerShiftCubit>()
                                        .handoverTiming =
                                    HandoverTiming.yesterday;
                                context.read<ValidationCubit>().validateField(
                                  'handoverTiming',
                                  true,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  10.verticalSpace,

                  Text(
                    context
                        .tr
                        .allHandoversShiftsAndSalesWillBeRecordedUnderTodayWorkday,
                    textAlign: TextAlign.center,
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
