import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/progress_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/styles/app_colors.dart';
import '../../../ui/widgets/manager_shift_management_widgets/final_handover_widgets/final_handover_widget.dart';
import '../../../ui/widgets/manager_shift_management_widgets/final_handover_widgets/no_final_handover_widget.dart';
import 'manager_main_screen_tab_strategy.dart';

class ManagerMainScreenFinalHandoverTabWidget
    extends ManagerMainScreenTabStrategy {
  final String shiftDate;
  final ShiftStatusType shiftStatus;
  final CurrentShiftEntity currentManagerShift;
  ManagerMainScreenFinalHandoverTabWidget({
    required this.shiftDate,
    required this.shiftStatus,
    required this.currentManagerShift,
  });

  @override
  Widget buildTabContent(BuildContext context) {
    ProgressEntity progress = currentManagerShift.progress;

    if (shiftStatus == ShiftStatusType.pending) {
      return NoFinalHanOverWidget(
        progress: progress,
        shiftDate: shiftDate,
        title: context.tr.shiftNotStarted,
        firstSubTitle: context.tr.uHaventStartedYourShiftYet,
        secondSubTitle: context.tr.uNeedToBeginTheShift,
        buttonText: context.tr.start_shift,
        buttonColor: AppColors.primaryLight,
        buttonOnTap: () {
          context.read<ManagerShiftCubit>().startManagerShift();
        },
      );
    } else if (shiftStatus == ShiftStatusType.inProgress) {
      return NoFinalHanOverWidget(
        progress: progress,
        shiftDate: shiftDate,
        title: context.tr.EndShiftFirst,
        firstSubTitle: context.tr.youNeedToEndYourShiftBeforeFinalHandOver,
        secondSubTitle: context.tr.wrapUpYourShiftActivities,
        buttonText: context.tr.end_shift,
        buttonColor: progress.hasEnded(shiftDate: shiftDate)
            ? AppColors.lightGreen
            : AppColors.red,
        buttonOnTap: () {
          NavigationService.I.pushNamed(
            AppRouteName.endManagerShiftScreen,
            arguments: {
              'handovers': currentManagerShift.handover,
              'managerName': currentManagerShift.shift.shiftDetails.managerName,
              'managerCubit': context.read<ManagerShiftCubit>(),
            },
          );
        },
      );
    } else {
      return FinalHandoverWidget(currentManagerShift: currentManagerShift);
    }
  }
}
