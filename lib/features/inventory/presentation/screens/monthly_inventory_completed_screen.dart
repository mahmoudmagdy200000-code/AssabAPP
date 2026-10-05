import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_svg.dart';
import '../widgets/export_inventory_bottom_sheet.dart';

class MonthlyInventoryCompletedScreen extends StatelessWidget {
  const MonthlyInventoryCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.monthlyRegularInventory,
            subtitle: context.tr.simplifiedMonthlyInventoryCount,
          ),
          20.verticalSpace,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.tr.inventoryComplete,
                                  style: AppStyles.s20W600.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ),
                              Text(
                                '00:48:32',
                                style: AppStyles.s13W600.copyWith(
                                  color: context.theme.primaryColor,
                                ),
                              ),
                              5.horizontalSpace,
                              AppSvg(
                                assetName: AppAssets.clockSvg,
                                width: 14.r,
                                height: 14.r,
                              ),
                            ],
                          ),
                          16.verticalSpace,
                          Text(
                            context.tr.youCanSaveAsADraftOrSubmitNowForReview,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          12.verticalSpace,
                          Container(
                            decoration: BoxDecoration(
                              color: context.customColor.text2,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.all(8.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        context.customColor.reversedTextColor,
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  padding: EdgeInsets.all(16.r),
                                  child: Column(
                                    children: [
                                      AppSvg(
                                        assetName: AppAssets.warning,
                                        width: 20.r,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.orange,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      8.verticalSpace,
                                      Text(
                                        context
                                            .tr
                                            .ifTheIndicatorAppearsSignificantlyOffCenterItMaySignalIncorrectQuantityInput,
                                        style: AppStyles.s14W400.copyWith(
                                          color: context.customColor.text3,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                12.verticalSpace,
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        context.customColor.reversedTextColor,
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  padding: EdgeInsets.all(16.r),
                                  child: Column(
                                    children: [
                                      AppSvg(
                                        assetName: AppAssets.ai,
                                        width: 20.r,
                                        colorFilter: ColorFilter.mode(
                                          context.theme.primaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      8.verticalSpace,
                                      Text(
                                        context
                                            .tr
                                            .smartMonthlyInventoryComparison,
                                        style: AppStyles.s14W500.copyWith(
                                          color: context.theme.primaryColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      8.verticalSpace,
                                      Text(
                                        context
                                            .tr
                                            .seeTheDifferenceBetweenThisMonthsInventoryAgainstLastMonthsInventory,
                                        style: AppStyles.s14W400.copyWith(
                                          color: context.customColor.text3,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      16.verticalSpace,
                                      Row(
                                        spacing: 18.r,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              spacing: 8.r,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 16.h,
                                                    decoration: ShapeDecoration(
                                                      color: context
                                                          .theme
                                                          .primaryColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              999.r,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  context.tr.thisMonth,
                                                  style: AppStyles.s14W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text4,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              spacing: 8.r,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 16.h,
                                                    decoration: ShapeDecoration(
                                                      color: context
                                                          .customColor
                                                          .text2,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              999.r,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  context.tr.previousMonth,
                                                  style: AppStyles.s14W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text4,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                12.verticalSpace,
                                ListView.builder(
                                  itemCount: 5,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.r,
                                        vertical: 12.r,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: context
                                            .customColor
                                            .reversedTextColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                        ),
                                      ),
                                      margin: EdgeInsets.only(bottom: 12.r),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 8.r,
                                        children: [
                                          Row(
                                            spacing: 16,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Mozzarella Cheese',
                                                  style: AppStyles.s14W500
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text1,
                                                      ),
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '32,600% ',
                                                      style: AppStyles.s12W500
                                                          .copyWith(
                                                            color: AppColors
                                                                .lightGreen,
                                                          ),
                                                    ),
                                                    TextSpan(
                                                      text: context.tr.increase,
                                                      style: AppStyles.s12W500
                                                          .copyWith(
                                                            color: context
                                                                .customColor
                                                                .text3,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 12.r,
                                                  decoration: ShapeDecoration(
                                                    color: context
                                                        .customColor
                                                        .text2,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            999.r,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 200,
                                                  height: 12.r,
                                                  decoration: ShapeDecoration(
                                                    color: context
                                                        .theme
                                                        .primaryColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            999.r,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '980 Kg',
                                                style: AppStyles.s14W400
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text3,
                                                    ),
                                              ),
                                              Text(
                                                '3 Kg',
                                                style: AppStyles.s14W400
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text3,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  ButtonTextIcon(
                    onTap: () {
                      AppBottomSheet.showModal(
                        context,
                        (context) => const ExportInventoryBottomSheet(),
                      );
                    },
                    label: context.tr.exportReport,
                    icon: AppSvg(
                      assetName: AppAssets.upload,
                      width: 14.r,
                      height: 14.r,
                      colorFilter: ColorFilter.mode(
                        context.customColor.text1,
                        BlendMode.srcIn,
                      ),
                    ),
                    spaceBetweenTextAndIcon: 7.w,
                    padding: EdgeInsets.symmetric(vertical: 18.r),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
