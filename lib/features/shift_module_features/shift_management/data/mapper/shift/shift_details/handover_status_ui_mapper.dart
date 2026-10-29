import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/enums/shift_status/shift_handover_status.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../domain/entity/manager_shift/current_shift/handover_details_entity.dart';
import '../../../../presentation/logic/manager_shift/manager_shift_cubit.dart';
import '../../../../presentation/ui/widgets/manager_shift_management_widgets/manager_approve_button_widget.dart';
import '../../../../presentation/ui/widgets/manager_shift_management_widgets/manager_handover_request_edit_widget.dart';
import '../../../../presentation/ui/widgets/manager_shift_management_widgets/manager_reject_handover_button.dart';

extension HandoverStatusUIMapper on HandoverStatus {
  String get label {
    switch (this) {
      case HandoverStatus.pending:
        return S.current.pending;
      case HandoverStatus.accepted:
        return S.current.completed_name;
      case HandoverStatus.rejected:
        return S.current.rejected;
      case HandoverStatus.notSubmitted:
        return S.current.notSubmitted;
    }
  }

  String text(String cashierName, String? dateAndTime) {
    switch (this) {
      case HandoverStatus.pending:
        return S.current.handoverPendingDesc(cashierName);
      case HandoverStatus.accepted:
        return S.current.handoverAcceptedDesc(cashierName, dateAndTime!);
      case HandoverStatus.rejected:
        return S.current.handoverRejectedDesc(cashierName);
      case HandoverStatus.notSubmitted:
        return S.current.noHandoverSubmittedYet;
    }
  }

  String handoverRequestsTextDesc(String? dateAndTime) {
    switch (this) {
      case HandoverStatus.pending:
        return S.current.handoverPendingDesc(dateAndTime ?? '');
      case HandoverStatus.accepted:
        return S.current.youAcceptedThisHandover(dateAndTime ?? '');
      case HandoverStatus.rejected:
        return S.current.youRejectedThisHandover(dateAndTime ?? '');
      case HandoverStatus.notSubmitted:
        return S.current.noHandoverSubmittedYet;
    }
  }

  String managerPovHandoverDetailsText(
    String? cashierName,
    String? dateAndTime,
  ) {
    switch (this) {
      case HandoverStatus.pending:
        return S.current.waitingForYourApproval;
      case HandoverStatus.accepted:
        return S.current.handoverApprovedByYou(dateAndTime!);
      case HandoverStatus.rejected:
        return S.current.youRequestedCashierToMakeCorrections(cashierName!);
      case HandoverStatus.notSubmitted:
        return S.current.noHandoverSubmittedYet;
    }
  }

  Widget managerPovHandoverDetailsActionButtons({
    required HandoverDetailsEntity handover,
    bool isEnabled = true,
    required String managerName,
    required BuildContext context,
  }) {
    switch (this) {
      case HandoverStatus.pending:
        return SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ManagerRejectHandoverButton(
                shiftId: handover.cashierShiftId,
                openedFromModalSheet: true,
                successFunction: () {
                  context.read<ManagerShiftCubit>().getCurrentShift();
                },
              ),

              ManagerApproveButtonWidget(
                buttonWidth: 150.w,
                cashierShiftId: handover.cashierShiftId,
                cashierName: handover.cashierName,
                cashFrom: handover.cashierName,
                cashGiven: handover.handoverAmount,
                variance: handover.varianceAmount,
                managerName: managerName,
                successFunction: () {
                  context.read<ManagerShiftCubit>().getCurrentShift();
                },
                isTheCurrentStatusRejected:
                    handover.handoverStatus == HandoverStatus.rejected,
                openedFromModalSheet: true,
              ),
            ],
          ),
        );
      case HandoverStatus.accepted:
        return Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ManagerEditHandoverButton(
                  cashierShiftId: handover.cashierShiftId,
                  cashierName: handover.cashierName,
                  managerName: managerName,
                  successFunction: () {
                    context.read<ManagerShiftCubit>().getCurrentShift();
                  },
                  isEnabled: isEnabled,
                  openedFromModalSheet: true,
                ),
              ),
            ],
          ),
        );
      case HandoverStatus.rejected:
        return SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 15.w,
            children: [
              Expanded(
                child: ManagerEditHandoverButton(
                  cashierShiftId: handover.cashierShiftId,
                  cashierName: handover.cashierName,
                  managerName: managerName,
                  successFunction: () {
                    context.read<ManagerShiftCubit>().getCurrentShift();
                  },
                  isEnabled: isEnabled,
                  openedFromModalSheet: true,
                ),
              ),

              ManagerApproveButtonWidget(
                buttonWidth: 150.w,
                cashierShiftId: handover.cashierShiftId,
                cashierName: handover.cashierName,
                cashFrom: handover.cashierName,
                cashGiven: handover.handoverAmount,
                variance: handover.varianceAmount,
                managerName: managerName,
                successFunction: () {
                  context.read<ManagerShiftCubit>().getCurrentShift();
                },
                isTheCurrentStatusRejected:
                    handover.handoverStatus == HandoverStatus.rejected,
                openedFromModalSheet: true,
              ),
            ],
          ),
        );
      case HandoverStatus.notSubmitted:
        return SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ManagerRejectHandoverButton(
                shiftId: handover.cashierShiftId,
                openedFromModalSheet: true,
                successFunction: () {
                  context.read<ManagerShiftCubit>().getCurrentShift();
                },
              ),

              ManagerApproveButtonWidget(
                buttonWidth: 150.w,
                cashierShiftId: handover.cashierShiftId,
                cashierName: handover.cashierName,
                cashFrom: handover.cashierName,
                cashGiven: handover.handoverAmount,
                variance: handover.varianceAmount,
                managerName: managerName,
                successFunction: () {
                  context.read<ManagerShiftCubit>().getCurrentShift();
                },
                isTheCurrentStatusRejected:
                    handover.handoverStatus == HandoverStatus.rejected,
                openedFromModalSheet: true,
              ),
            ],
          ),
        );
    }
  }

  Color get cardColor {
    switch (this) {
      case HandoverStatus.pending:
        return AppColors.darkOrange.withAlpha(10);
      case HandoverStatus.accepted:
        return AppColors.green.withAlpha(10);
      case HandoverStatus.rejected:
        return AppColors.red.withAlpha(10);
      case HandoverStatus.notSubmitted:
        return AppColors.darkGray.withAlpha(10);
    }
  }

  Color get textColor {
    switch (this) {
      case HandoverStatus.pending:
        return AppColors.darkOrange;
      case HandoverStatus.accepted:
        return AppColors.darkGreen;
      case HandoverStatus.rejected:
        return Colors.red;
      case HandoverStatus.notSubmitted:
        return AppColors.sBlack;
    }
  }
}
