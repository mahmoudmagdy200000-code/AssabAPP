import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/approve_handover_widgets/successfully_approved_handover_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../../core/utils/app_dialog.dart';
import '../../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../../core/widgets/app_button_loading.dart';
import '../../../../logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';

class ApprovedHandoverFromModalSheetWidget extends StatefulWidget {
  const ApprovedHandoverFromModalSheetWidget({
    super.key,
    required this.shiftId,
    required this.currentCashierName,
    required this.successFunction,
    this.openedFromModalSheet = false,
  });

  final String currentCashierName;
  final String shiftId;
  final bool openedFromModalSheet;
  final Function() successFunction;

  @override
  State<ApprovedHandoverFromModalSheetWidget> createState() =>
      _ApprovedHandoverFromModalSheetWidgetState();
}

class _ApprovedHandoverFromModalSheetWidgetState
    extends State<ApprovedHandoverFromModalSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      // height: 350.h,
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w, vertical: 10.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr.approveHandover, style: AppStyles.s18W500),

            10.verticalSpace,
            Text(
              context.tr.yAreApprovingThisHandoverFromCashier,
              style: AppStyles.s13W400.copyWith(
                color: context.customColor.text4,
              ),
            ),

            20.verticalSpace,
            Row(
              children: [
                Container(
                  width: 5.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),

                10.horizontalSpace,
                Expanded(
                  child: Text(
                    context
                        .tr
                        .thisActionIsIrreversibleAndWillCloseHandoverPermanently,
                    style: AppStyles.s13W400.copyWith(
                      color: context.customColor.text4,
                    ),
                  ),
                ),
              ],
            ),

            100.verticalSpace,

            BlocConsumer<
              ApproveAndRejectHandoverCubit,
              ApproveAndRejectHandoverState
            >(
              listener: (context, state) {
                if (state is HandoverActionSuccess) {
                  NavigationService.I.pop(context);
                  if (widget.openedFromModalSheet &&
                      NavigationService.I.canPop()) {
                    NavigationService.I.pop();
                  }

                  AppBottomSheet.showModal(
                    context,
                    (context) => SuccessfullyApprovedHandoverBottomSheetWidget(
                      cashierName: widget.currentCashierName,
                    ),
                  );

                  widget.successFunction();
                } else if (state is HandoverActionFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state is HandoverActionLoading) {
                  return const AppButtonLoading();
                }

                return AppButton(
                  onClick: () {
                    context
                        .read<ApproveAndRejectHandoverCubit>()
                        .approveHandover(shiftId: widget.shiftId);
                  },
                  text: context.tr.approveHandover,
                  borderRadius: BorderRadius.circular(10.r),
                  enabled: true,
                  background: AppColors.primaryLight,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
