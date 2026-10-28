import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/shift_status_ui_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/shift_details/shift_details_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/tabs_widgets/reassigned_to_me_shift_details_tab_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/tabs_widgets/sales_and_handover_tab_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/tabs_widgets/shift_details_tab_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/tabs_widgets/shift_tab_widget_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../domain/entity/shift/shift_entity.dart';
import '../../../arguments/shift_arguments.dart';
import '../shift_details_container_widget.dart';
import '../shift_progress_indicator_widget.dart';

class AllDetailsTabWidget implements ShiftTabStrategy {
  @override
  Widget buildTabContent(
    BuildContext context, {
    required ShiftEntity shift,
    ShiftArguments? shiftArguments,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShiftDetailsContainerWidget(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        context.tr.shiftProgress,
                        style: AppStyles.s16W600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    10.horizontalSpace,
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: shift.status.cardColor(context),
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Text(
                        shift.status.label(
                          context,
                          isReassignedToMe:
                              shift.isShiftReassignedToMe ?? false,
                        ),
                        style: AppStyles.s12W500.copyWith(
                          color: shift.status.textColor(context),
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
                  startTime: shift.shiftTimeDetails.startTime,
                  endTime: shift.shiftTimeDetails.endTime,
                  actualEnd: shift.actualEndTime,
                  actualStart: shift.actualStartTime,
                ),

                10.verticalSpace,

                shift.status.shiftDetailsAppButton(
                  context,
                  shiftId: shift.id,
                  reassignmentEntity: shift.reassignment,
                  cashierEntity: shift.cashier,
                  shift: shift,
                  isCashier: context.read<ShiftDetailsCubit>().isCashier,
                ),
              ],
            ),
          ),

          15.verticalSpace,
          shift.isShiftReassignedToMe ?? false
              ? ReassignedToMeShiftDetailsTabWidget().buildTabContent(
                  context,
                  shift: shift,
                  shiftArguments: shiftArguments,
                )
              : ShiftDetailsTabWidget().buildTabContent(
                  context,
                  shift: shift,
                  shiftArguments: shiftArguments,
                ),

          15.verticalSpace,
          SalesAndHandoverTabWidget(allowScroll: false).buildTabContent(
            context,
            shift: shift,
            shiftArguments: shiftArguments,
          ),
        ],
      ),
    );
  }
}
