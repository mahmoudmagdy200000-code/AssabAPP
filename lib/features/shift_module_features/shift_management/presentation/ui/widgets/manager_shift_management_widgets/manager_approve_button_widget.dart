import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/utils/currency_normalizer.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/features/branch_manager_requests/presentation/widgets/accept_handover_sheet_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/widgets/app_button.dart';

class ManagerApproveButtonWidget extends StatelessWidget {
  const ManagerApproveButtonWidget({
    super.key,
    required this.cashierShiftId,
    required this.cashierName,
    required this.managerName,
    required this.successFunction,
    this.cashGiven,
    this.variance,
    this.cashFrom,
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
  final num? cashGiven;
  final num? variance;
  final String? cashFrom;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ApproveAndRejectHandoverCubit,
      ApproveAndRejectHandoverState
    >(
      builder: (context, state) {
        if (state is HandoverActionLoading) {
          return AppButtonLoading(width: buttonWidth ?? 150.w);
        } else {
          return AppButton(
            onClick: () {
              AppBottomSheet.showModal(
                context,
                (sheetContext) => BlocProvider(
                  create: (_) => getIt<ApproveAndRejectHandoverCubit>(),
                  child: AcceptHandoverSheetWidget(
                    shiftId: cashierShiftId,
                    cashFrom: cashFrom ?? cashierName,
                    cashGiven: CurrencyNormalizer.formatSar(cashGiven ?? 0),
                    variance: CurrencyNormalizer.formatSar(variance ?? 0),
                    successFunction: successFunction,
                    actorRole: UserType.branchManager,
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
