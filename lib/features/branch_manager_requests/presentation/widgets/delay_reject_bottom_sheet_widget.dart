import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../cubit/reject_approve_delay/reject_approve_delay_cubit.dart';

class DelayRejectBottomSheetWidget extends StatelessWidget {
  final String orderId;

  const DelayRejectBottomSheetWidget({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 40.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.rejectDelayRequestForAllItems,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    12.verticalSpace,
                    Text(
                      context.tr.youAreAboutToRejectTheSuppliersDelayRequest,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    Text(
                      context
                          .tr
                          .sinceTheSupplierCannotDeliverByTheOriginalDateThisOrderWillBeCancelledAndRemovedFromActiveProcessing,
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
            BlocSelector<ValidationCubit, ValidationState, bool>(
              selector: (state) => state.enableButton,
              builder: (context, state) {
                return AppButton(
                  onClick: () {
                    NavigationService.I.pop();

                    context.read<RejectApproveDelayCubit>().rejectDelay(
                      id: orderId,
                      reason: context.read<ValidationCubit>().getFieldValue(
                        'reason',
                      ),
                    );
                  },
                  enabled: state,
                  text: context.tr.confirmRejection,
                  background: context.customColor.error,
                  borderRadius: BorderRadius.circular(12.r),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
