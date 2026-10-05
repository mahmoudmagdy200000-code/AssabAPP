import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/widgets/app_button.dart';
import 'approve_handover_widgets/approve_handover_from_rejection_status_modal_sheet_widget.dart';
import 'approve_handover_widgets/approve_handover_modal_sheet_widget.dart';

class ManagerApproveButtonWidget extends StatelessWidget {
  const ManagerApproveButtonWidget({
    super.key,
    required this.cashierShiftId,
    required this.cashierName,
    required this.managerName,
    required this.successFunction,
    this.isTheCurrentStatusRejected = false,
    this.openedFromModalSheet = false,
    this.buttonWidth,
  });
  final String cashierShiftId;
  final String cashierName;
  final String managerName;
  final Function() successFunction;
  final bool openedFromModalSheet;
  final bool isTheCurrentStatusRejected;

  final double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ApproveAndRejectHandoverCubit,
      ApproveAndRejectHandoverState
    >(
      builder: (context, state) {
        if (state is HandoverActionLoading) {
          return AppButtonLoading(width: 150.w);
        } else {
          return AppButton(
            onClick: () {
              // context.read<ApproveAndRejectHandoverCubit>().approveHandover(shiftId);

              final approveAndRejectHandoverCubit = context
                  .read<ApproveAndRejectHandoverCubit>();

              AppBottomSheet.showModal(
                context,
                (sheetContext) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: approveAndRejectHandoverCubit),
                  ],
                  child: isTheCurrentStatusRejected
                      ? ApprovedHandoverFromRejectionStatusModalSheetWidget(
                          shiftId: cashierShiftId,
                          currentCashierName: cashierName,
                          openedFromModalSheet: openedFromModalSheet,
                          successFunction: successFunction,
                        )
                      : ApprovedHandoverFromModalSheetWidget(
                          shiftId: cashierShiftId,
                          currentCashierName: cashierName,
                          openedFromModalSheet: openedFromModalSheet,
                          successFunction: successFunction,
                        ),
                ),
                isScrollControlled: true,
              );
            },
            enabled: true,
            background: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10.r),
            width: buttonWidth ?? double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            text: context.tr.approve,
          );
        }
      },
    );
  }
}
