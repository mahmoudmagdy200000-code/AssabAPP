import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/reject_handover_widgets/reject_handover_modal_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/widgets/app_button.dart';

class ManagerRejectHandoverButton extends StatelessWidget {
  const ManagerRejectHandoverButton({
    super.key,
    required this.shiftId,
    this.buttonWidth,
    required this.openedFromModalSheet,
    required this.successFunction,
  });

  final double? buttonWidth;
  final String shiftId;
  final bool openedFromModalSheet;
  final Function() successFunction;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onClick: () {
        AppBottomSheet.showModal(
          context,
          (sheetContext) => BlocProvider(
            create: (_) => getIt<ApproveAndRejectHandoverCubit>(),
            child: RejectHandoverModalSheetWidget(
              shiftId: shiftId,
              openedFromModalSheet: openedFromModalSheet,
              successFunction: successFunction,
              actorRole: UserType.branchManager,
            ),
          ),
          isScrollControlled: true,
        );
      },
      text: context.tr.reject,
      enabled: true,
      isTransparent: true,
      textColor: AppColors.red,
      borderRadius: BorderRadius.circular(10.r),
      width: buttonWidth ?? 150.w,
      padding: EdgeInsets.symmetric(vertical: 15.h),
    );
  }
}
