import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/widgets/app_button.dart';
import '../../../../domain/entity/manager_shift/current_shift/handover_details_entity.dart';
import 'cashier_handover_details_widget.dart';

class ManagerSeeDetailsButtonWidget extends StatelessWidget {
  const ManagerSeeDetailsButtonWidget({
    super.key,
    this.buttonWidth,
    required this.handover,
  });

  final double? buttonWidth;
  final HandoverDetailsEntity handover;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onClick: () {
        final managerShiftCubit = context.read<ManagerShiftCubit>();
        final approveAndRejectHandoverCubit = context
            .read<ApproveAndRejectHandoverCubit>();

        AppBottomSheet.showModal(
          context,
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: managerShiftCubit),
              BlocProvider.value(value: approveAndRejectHandoverCubit),
            ],
            child: CashierHandoverDetails(
              handover: handover,
              managerName:
                  managerShiftCubit.managerShift.shift.shiftDetails.managerName,
            ),
          ),

          isScrollControlled: true,
        );
      },
      enabled: true,
      isTransparent: true,
      width: buttonWidth,
      borderRadius: BorderRadius.circular(10.r),
      padding: EdgeInsets.symmetric(vertical: 15.h),
      text: context.tr.seeDetails,
    );
  }
}
