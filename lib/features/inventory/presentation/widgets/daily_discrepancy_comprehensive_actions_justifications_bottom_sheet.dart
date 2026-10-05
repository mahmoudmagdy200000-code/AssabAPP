import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';

class DailyDiscrepancyComprehensiveActionsJustificationsBottomSheet
    extends StatelessWidget {
  const DailyDiscrepancyComprehensiveActionsJustificationsBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                Text(
                  context.tr.addJustification,
                  style: AppStyles.s20W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ).sliverBoxAdapter,
                8.verticalSpace.sliverBoxAdapter,
                // Description
                Text(
                  context.tr.explainWhyThereIsAShortageInThisItemsRecord,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ).sliverBoxAdapter,
                16.verticalSpace.sliverBoxAdapter,
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
                ).sliverBoxAdapter,
                16.verticalSpace.sliverBoxAdapter,
                SliverList.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ContainerCustomTextField(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: context.customColor.reversedTextColor,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                padding: EdgeInsets.all(16.r),
                                child: Row(
                                  children: [
                                    const PurchaseItemImage(),
                                    12.horizontalSpace,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Item Name',
                                            style: AppStyles.s14W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                context.tr.shortageAmount,
                                                style: AppStyles.s11W400
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text3,
                                                    ),
                                              ),
                                              const SaudiRiyalSvgWidget(),
                                              Text(
                                                '100.00',
                                                style: AppStyles.s11W500
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text1,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              10.verticalSpace,
                              Container(
                                decoration: BoxDecoration(
                                  color: context.customColor.reversedTextColor,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                padding: EdgeInsets.all(16.r),
                                child: ContainerCustomTextField(
                                  label: context.tr.justification,
                                  backgroundColor: Colors.transparent,
                                  child: const CustomTextField(
                                    maxLines: 2,
                                    hintText: 'e.g. damaged, expired, theft',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (index != 4) 12.verticalSpace,
                      ],
                    );
                  },
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
