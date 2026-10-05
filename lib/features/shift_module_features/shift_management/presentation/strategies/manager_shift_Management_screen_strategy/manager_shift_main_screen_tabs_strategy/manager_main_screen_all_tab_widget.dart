import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/strategies/manager_shift_Management_screen_strategy/manager_shift_main_screen_tabs_strategy/manager_main_screen_shift_details_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../../data/mapper/shift/shift_details/shift_status_ui_mapper.dart';
import '../../../ui/widgets/shift_details_widgets/shift_details_container_widget.dart';
import '../../../ui/widgets/shift_details_widgets/shift_progress_indicator_widget.dart';
import 'manager_main_screen_handoffs_received_tab_widget.dart';
import 'manager_main_screen_tab_strategy.dart';

class ManagerMainScreenAllTabWidget extends ManagerMainScreenTabStrategy {
  final CurrentShiftEntity managerShift;

  ManagerMainScreenAllTabWidget({required this.managerShift});

  @override
  Widget buildTabContent(BuildContext context) {
    return Column(
      children: [
        ShiftDetailsContainerWidget(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.tr.shiftProgress, style: AppStyles.s16W600),

                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: managerShift.shift.status.cardColor(context),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: context.customColor.border,
                        width: 1.w,
                      ),
                    ),
                    child: Text(
                      managerShift.shift.status.label(context),
                      style: AppStyles.s12W500.copyWith(
                        color: managerShift.shift.status.textColor(context),
                      ),
                    ),
                  ),
                ],
              ),

              10.verticalSpace,

              Text(
                context.tr.totalHoursDesc,
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text4,
                ),
              ),

              15.verticalSpace,

              const CustomDivider(),

              10.verticalSpace,

              ShiftProgressIndicator(
                startTime: managerShift.progress.startTime ?? '00:00',
                endTime: managerShift.progress.endTime ?? '00:00',
                actualEnd: managerShift.shift.timestamps.actualEnd,
                actualStart: managerShift.shift.timestamps.actualStart,
              ),

              10.verticalSpace,

              BlocBuilder<ManagerShiftCubit, ManagerShiftState>(
                builder: (context, state) {
                  if (state is ManagerShiftButtonLoading) {
                    return const AppButtonLoading();
                  } else {
                    return managerShift.shift.status.managerShiftCardButton(
                      context,
                      currentManagerShift: managerShift,
                      hasEnded: managerShift.progress.hasEnded(
                        shiftDate: managerShift.shift.shiftDate,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),

        10.verticalSpace,

        ManagerMainScreenShiftDetailsTabWidget(
          managerShift: managerShift.shift,
          shiftProgress: managerShift.progress,
        ).buildTabContent(context),

        10.verticalSpace,

        ManagerMainScreenHandoffsReceivedTabWidget(
          managerShift: managerShift,
        ).buildTabContent(context),
      ],
    );
  }
}
