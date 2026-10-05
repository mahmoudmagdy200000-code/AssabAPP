import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/supplier_returns/presentation/cubit/supplier_approve_reject_return/supplier_approve_reject_return_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../returns_management/presentation/widgets/approve_rejecte_success_bottom_sheet_widget.dart';
import '../cubit/supplier_approve_reject_return/supplier_approve_reject_return_cubit.dart';

class SupplierRejectReturnItemBottomSheetWidgte extends StatelessWidget {
  final String id;

  const SupplierRejectReturnItemBottomSheetWidgte({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.rejectReturnRequest,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    12.verticalSpace,
                    Text(
                      context.tr.youAreAboutToRejectThisReturnRequest,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    25.verticalSpace,
                    Text(
                      context
                          .tr
                          .pleaseIncludeAReasonSoTheyUnderstandYourPosition,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      context
                          .tr
                          .onceSubmittedTheBuyerWillBeNotifiedAndCanEitherAcceptYourDecisionOrEscalateItToManagementForReview,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    10.verticalSpace,
                    ContainerCustomTextField(
                      label: context.tr.reasonForRejection,
                      backgroundColor: Colors.transparent,
                      child: CustomTextField(
                        maxLines: 5,
                        hintText: context.tr.reasonForRejection,
                        onChanged: (value) {
                          context
                              .read<ValidationCubit>()
                              .validateFieldAndStoreValue(
                                fieldName: 'reason',
                                value: value,
                                isValid: value.isNotEmpty,
                              );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            BlocConsumer<
              SupplierApproveRejectReturnCubit,
              SupplierApproveRejectReturnState
            >(
              listener: (context, state) {
                if (state is SupplierApproveRejectReturnSuccess) {
                  NavigationService.I.popToFirst();

                  AppBottomSheet.customPageRoute(
                    context,
                    (context) => ApproveRejecteSuccessBottomSheetWidget(
                      title: context.tr.returnRejected,
                      description: context
                          .tr
                          .theyCanNowEitherAcceptYourDecisionOrEscalateItForManagementLevelResolution,
                    ),
                  );
                } else if (state is SupplierApproveRejectReturnFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                return BlocSelector<ValidationCubit, ValidationState, bool>(
                  selector: (state) => state.enableButton,
                  builder: (context, validationState) {
                    if (state is SupplierApproveRejectReturnLoading) {
                      return AppButtonLoading(
                        background: context.customColor.error.withValues(
                          alpha: 0.5,
                        ),
                      );
                    }

                    return AppButton(
                      text: context.tr.rejectAndSendFeedback,
                      onClick: () {
                        context
                            .read<SupplierApproveRejectReturnCubit>()
                            .rejectReturn(
                              id: id,
                              reason: context
                                  .read<ValidationCubit>()
                                  .getFieldValue('reason'),
                            );
                      },
                      enabled: validationState,
                      padding: EdgeInsets.symmetric(vertical: 18.r),
                      textColor: context.customColor.reversedTextColor,
                      background: context.customColor.error,
                      borderRadius: BorderRadius.circular(20.r),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
