import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class DailyDiscrepancyQuickActionsJustificationsBottomSheet
    extends StatelessWidget {
  const DailyDiscrepancyQuickActionsJustificationsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.addJustification,
                  style: AppStyles.s20W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                8.verticalSpace,
                // Description
                Text(
                  context.tr.explainWhyThereIsAShortageInThisItemsRecord,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                16.verticalSpace,
                // Warning
                Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 155.h,
                      color: context.theme.primaryColor,
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.onceSubmitted,
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            context
                                .tr
                                .itWillBeSentForApprovalByTheBrandManagerOrStoreOwner,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            context.tr.ifApprovedTheItemWillBeLoggedAsWaste,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            context
                                .tr
                                .ifRejectedTheValueWillBeAddedToYourAccountStatementAsALiability,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                // Text Field
                ContainerCustomTextField(
                  label: context.tr.reasonForShortage,
                  child: CustomTextField(
                    maxLines: 4,
                    hintText: context.tr.reason,
                  ),
                ),
              ],
            ),
          ),
          20.verticalSpace,
          AppButton(
            onClick: () {
              // Handle confirm & submit
            },
            text: context.tr.confirmAndSubmit,
            background: const Color(0xFFF4F4F4),
            textColor: context.customColor.text3,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ],
      ),
    );
  }
}
