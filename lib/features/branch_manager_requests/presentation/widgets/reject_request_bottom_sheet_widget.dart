import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/features/branch_manager_requests/data/models/reject_all_order_request.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/approve_or_reject_order/approve_or_reject_order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../cubit/approve_or_reject_order/approve_or_reject_order_cubit.dart';
import 'request_approved_success_bottom_sheet_widget.dart';

class RejectRequestBottomSheetWidget extends StatelessWidget {
  final String orderId;

  const RejectRequestBottomSheetWidget({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.rejectRequest,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    context
                        .tr
                        .youreAboutToRejectThisTransferRequestFromAnotherBranch,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  16.verticalSpace,
                  const CustomDivider(),
                  16.verticalSpace,
                  LabelTextField(
                    text: context.tr.reasonForRejection,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: context.customColor.border),
                    ),
                    child: CustomTextField(
                      hintText: context
                          .tr
                          .egItemUnavailableLowStockOrNotAuthorizedForTransfer,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
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
          BlocConsumer<ApproveOrRejectOrderCubit, ApproveOrRejectOrderState>(
            listener: (context, state) {
              if (state is ApproveOrRejectOrderSuccess) {
                NavigationService.I.popToFirst();

                AppBottomSheet.pageRoute(
                  context,
                  (context) => Expanded(
                    child: RequestApprovedSuccessBottomSheetWidget(
                      title: context.tr.transferRequestRejected,
                      desc: context.tr.transferRequestRejectedDesc,
                    ),
                  ),
                );
              } else if (state is ApproveOrRejectOrderFailure) {
                AppDialog.showErrorDialog(
                  context: context,
                  failure: state.failure,
                );
              }
            },
            builder: (context, state) {
              if (state is ApproveOrRejectOrderLoading) {
                return const AppButtonLoading();
              }

              return Row(
                children: [
                  Expanded(
                    child: CustomTextButton(
                      text: context.tr.cancel,
                      onTap: () => NavigationService.I.pop(),
                      textColor: context.customColor.text1,
                      padding: EdgeInsets.symmetric(vertical: 17.r),
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: BlocSelector<ValidationCubit, ValidationState, bool>(
                      selector: (state) => state.enableButton,
                      builder: (context, state) {
                        return AppButton(
                          onClick: () {
                            context
                                .read<ApproveOrRejectOrderCubit>()
                                .rejectOrder(
                                  orderId: orderId,
                                  body: RejectAllOrderRequest(
                                    reason: context
                                        .read<ValidationCubit>()
                                        .getFieldValue('reason'),
                                  ),
                                );
                          },
                          enabled: state,
                          text: context.tr.reject,
                          background: context.customColor.error,
                          borderRadius: BorderRadius.circular(12.r),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
