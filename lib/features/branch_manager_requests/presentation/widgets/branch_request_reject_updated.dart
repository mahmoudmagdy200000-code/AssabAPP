import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_padding_widget.dart';
import '../cubit/branch_approve_or_reject_modification/branch_approve_or_reject_modification_cubit.dart';

class BranchRequestRejectUpdated extends StatelessWidget {
  final String title;
  final String orderId;
  final String itemId;

  const BranchRequestRejectUpdated({
    super.key,
    required this.title,
    required this.orderId,
    required this.itemId,
  });

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
                      title,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    12.verticalSpace,
                    Row(
                      children: [
                        Container(
                          width: 3.r,
                          height: 55.h,
                          color: context.customColor.error,
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Text(
                            context.tr.rejectQtyUpdateDesc,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ),
                      ],
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
                    context
                        .read<BranchApproveOrRejectModificationCubit>()
                        .rejectModification(
                          orderId: orderId,
                          itemId: itemId,
                          reason: context.read<ValidationCubit>().getFieldValue(
                            'reason',
                          ),
                        );

                    NavigationService.I.pop();
                  },
                  enabled: state,
                  text: context.tr.rejectModification,
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
