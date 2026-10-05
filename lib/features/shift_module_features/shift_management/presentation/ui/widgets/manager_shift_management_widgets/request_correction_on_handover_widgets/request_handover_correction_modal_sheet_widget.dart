import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/request_correction_on_handover_widgets/successfully_requested_handover_correction_bottom_sheet_widget.dart';
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
import '../../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../../core/widgets/label_text_field.dart';
import '../../../../logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';

class RequestHandoverCorrectionModalSheetWidget extends StatefulWidget {
  const RequestHandoverCorrectionModalSheetWidget({
    super.key,
    required this.shiftId,
    required this.currentCashierName,
    required this.managerName,
    required this.successFunction,
    this.openedFromModalSheet = false,
  });

  final String currentCashierName;
  final String managerName;
  final String shiftId;
  final bool openedFromModalSheet;
  final Function() successFunction;

  @override
  State<RequestHandoverCorrectionModalSheetWidget> createState() =>
      _RequestHandoverCorrectionModalSheetWidgetState();
}

class _RequestHandoverCorrectionModalSheetWidgetState
    extends State<RequestHandoverCorrectionModalSheetWidget> {
  @override
  void initState() {
    super.initState();
    managerCommentController = TextEditingController();
  }

  @override
  void dispose() {
    managerCommentController.dispose();
    super.dispose();
  }

  late final TextEditingController managerCommentController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: double.maxFinite,
        // height: 350.h,
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr.requestCorrections, style: AppStyles.s17W500),

              10.verticalSpace,
              Text(
                context.tr
                    .thisWillSendTheHandoverBackToCashierBasedOnManagerFeedBack(
                      widget.currentCashierName,
                      widget.managerName,
                    ),
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text4,
                ),
              ),

              10.verticalSpace,
              const CustomDivider(),
              15.verticalSpace,

              // Text(
              //     context.tr.managerComment,
              //     style:  AppStyles.s14W400
              // ),
              LabelTextField(
                text: context.tr.managerComment,
                style: AppStyles.s14W400,
                isLabelRequired: true,
              ),

              5.verticalSpace,
              Container(
                height: 130.h,
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 18.r, horizontal: 16.r),
                child: CustomTextField(
                  hintText: context.tr.provideAnySuggestionsOrNotes,
                  controller: managerCommentController,
                  maxLines: 5,
                  isEnabled: true,
                ),
              ),

              60.verticalSpace,

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
                      (context) =>
                          SuccessfullyRequestedHandoverCorrectionBottomSheetWidget(
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

                  return ValueListenableBuilder<TextEditingValue>(
                    valueListenable: managerCommentController,
                    builder: (_, value, _) {
                      return AppButton(
                        onClick: () {
                          context
                              .read<ApproveAndRejectHandoverCubit>()
                              .requestHandoverCorrection(
                                shiftId: widget.shiftId,
                                managerComment: managerCommentController.text,
                              );
                        },
                        text: context.tr.requestCorrections,
                        borderRadius: BorderRadius.circular(10.r),
                        enabled: value.text.isNotEmpty,
                        background: AppColors.primaryLight,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
