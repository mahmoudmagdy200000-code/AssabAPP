import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/features/branch_manager_requests/presentation/widgets/cashier_variance_responsibility_amount_widget.dart';
import 'package:assab/features/branch_manager_requests/presentation/widgets/responsibility_rejected_sheet_widget.dart';
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
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../cubit/approve_or_reject_responsibility/approve_or_reject_responsibility_cubit.dart';
import '../cubit/get_responsibility_details/get_responsibility_details_cubit.dart';

class RejectResponsibilitySheetWidget extends StatefulWidget {
  const RejectResponsibilitySheetWidget({
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
  State<RejectResponsibilitySheetWidget> createState() =>
      _RejectResponsibilitySheetWidgetState();
}

class _RejectResponsibilitySheetWidgetState
    extends State<RejectResponsibilitySheetWidget> {
  @override
  void initState() {
    super.initState();
    context.read<GetResponsibilityDetailsCubit>().getResponsibilityDetails(
      widget.shiftId,
    );
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
              Text(context.tr.rejectResponsibility, style: AppStyles.s17W500),

              10.verticalSpace,
              Text(
                context.tr.youAreAboutToRejectResponsibilityForVariance,
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text4,
                ),
              ),

              10.verticalSpace,
              const CustomDivider(),
              15.verticalSpace,

              BlocBuilder<
                GetResponsibilityDetailsCubit,
                GetResponsibilityDetailsState
              >(
                builder: (context, state) {
                  if (state is GetResponsibilityDetailsLoading) {
                    return const AppLoadingWidget();
                  }
                  if (state is GetResponsibilityDetailsFailure) {
                    return AppFailureWidget(
                      failure: state.failure,
                      onRetry: () {
                        context
                            .read<GetResponsibilityDetailsCubit>()
                            .getResponsibilityDetails(widget.shiftId);
                      },
                    );
                  }
                  if (state is GetResponsibilityDetailsSuccess) {
                    final cashier = state.responsibilityDetails;
                    return CashierVarianceResponsibilityAmountWidget(
                      cashier: cashier,
                    );
                  }

                  return const SizedBox.shrink();
                },
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
                  hintText: context.tr.brieflyExplainWhyYouAreNotResponsible,
                  controller: managerCommentController,
                  maxLines: 5,
                  isEnabled: true,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 70.h),
                child:
                    BlocConsumer<
                      ApproveOrRejectResponsibilityCubit,
                      ApproveOrRejectResponsibilityState
                    >(
                      listener: (context, state) {
                        if (state is ApproveOrRejectResponsibilitySuccess) {
                          NavigationService.I.pop(context);
                          NavigationService.I.pop(context);

                          AppBottomSheet.showModal(
                            context,
                            (context) => ResponsibilityRejectedSheetWidget(
                              shiftId: widget.shiftId,
                            ),
                          );

                          widget.successFunction();
                        } else if (state
                            is ApproveOrRejectResponsibilityFailed) {
                          AppDialog.showErrorDialog(
                            context: context,
                            failure: state.failure,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is ApproveOrRejectResponsibilityLoading) {
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
                                    .read<ApproveOrRejectResponsibilityCubit>()
                                    .rejectResponsibility(
                                      shiftId: widget.shiftId,
                                      managerComment:
                                          managerCommentController.text,
                                    );
                              },
                              text: context.tr.rejectResponsibility,
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
