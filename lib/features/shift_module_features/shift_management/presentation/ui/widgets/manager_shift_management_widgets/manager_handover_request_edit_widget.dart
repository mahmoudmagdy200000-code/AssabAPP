import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/request_correction_on_handover_widgets/request_handover_correction_modal_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../core/widgets/app_svg.dart';

class ManagerEditHandoverButton extends StatelessWidget {
  const ManagerEditHandoverButton({
    super.key,
    this.buttonWidth,
    required this.isEnabled,
    required this.cashierName,
    required this.managerName,
    required this.cashierShiftId,
    required this.successFunction,
    this.openedFromModalSheet = false,
  });

  final double? buttonWidth;
  final bool openedFromModalSheet;
  final bool isEnabled;
  final String cashierName;
  final String managerName;
  final String cashierShiftId;
  final Function() successFunction;

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: isEnabled
          ? () {
              // context.read<ApproveAndRejectHandoverCubit>().requestHandoverCorrection(shiftId: shiftId);

              final approveAndRejectHandoverCubit = context
                  .read<ApproveAndRejectHandoverCubit>();

              AppBottomSheet.showModal(
                context,
                (sheetContext) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: approveAndRejectHandoverCubit),
                  ],
                  child: RequestHandoverCorrectionModalSheetWidget(
                    shiftId: cashierShiftId,
                    currentCashierName: cashierName,
                    managerName: managerName,
                    openedFromModalSheet: openedFromModalSheet,
                    successFunction: successFunction,
                  ),
                ),
                isScrollControlled: true,
              );
            }
          : () {},
      child: Container(
        width: buttonWidth ?? double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.lightBackground : AppColors.lightGray,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: context.customColor.border, width: 1.w),
        ),

        child: isEnabled
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppSvg(assetName: AppAssets.edit, width: 20.w),
                  10.horizontalSpace,
                  Text(context.tr.editHandover, style: AppStyles.s13W500),
                ],
              )
            : Text(
                context.tr.cantRequestCorrectionsAnymore,
                style: AppStyles.s13W500,
              ),
      ),
    );
  }
}
