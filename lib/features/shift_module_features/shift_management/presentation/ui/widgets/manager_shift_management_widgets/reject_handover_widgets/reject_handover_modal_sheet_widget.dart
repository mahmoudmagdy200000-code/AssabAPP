import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/reject_handover_widgets/successfully_rejected_handover_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
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

class RejectHandoverModalSheetWidget extends StatefulWidget {
  const RejectHandoverModalSheetWidget({
    super.key,
    required this.shiftId,
    required this.successFunction,
    this.openedFromModalSheet = false,
    this.isFromRequestsScreen = false,
  });

  final Function() successFunction;
  final String shiftId;
  final bool openedFromModalSheet;
  final bool isFromRequestsScreen;

  @override
  State<RejectHandoverModalSheetWidget> createState() =>
      _RejectHandoverModalSheetWidgetState();
}

class _RejectHandoverModalSheetWidgetState
    extends State<RejectHandoverModalSheetWidget> {
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
              Text(context.tr.rejectHandover, style: AppStyles.s17W500),

              10.verticalSpace,
              Text(
                context
                    .tr
                    .youAreRejectingThisHandoverDueToIssuesOrInconsistencies,
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
                text: context.tr.reasonForRejection,
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

              Padding(
                padding: EdgeInsets.only(top: 70.h),
                child:
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
                                SuccessfullyRejectedHandoverBottomSheetWidget(
                                  shiftId: widget.shiftId,
                                  isFromRequestsScreen:
                                      widget.isFromRequestsScreen,
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
                          return const AppButtonLoading(
                            background: AppColors.red,
                          );
                        }

                        return ValueListenableBuilder<TextEditingValue>(
                          valueListenable: managerCommentController,
                          builder: (_, value, _) {
                            return AppButton(
                              onClick: () {
                                context
                                    .read<ApproveAndRejectHandoverCubit>()
                                    .rejectHandover(
                                      shiftId: widget.shiftId,
                                      managerComment:
                                          managerCommentController.text,
                                    );
                              },
                              text: context.tr.rejectAndAskForCorrection,
                              borderRadius: BorderRadius.circular(10.r),
                              enabled: value.text.isNotEmpty,
                              background: AppColors.red,
                            );
                          },
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
