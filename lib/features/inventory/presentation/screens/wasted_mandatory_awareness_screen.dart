import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';

import '../../domain/strategies/inventory_user_type.dart';
import '../widgets/wasted_mandatory_awareness_confirm_section.dart';

class WastedMandatoryAwarenessScreen extends StatelessWidget {
  final InventoryUserType userType;

  const WastedMandatoryAwarenessScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.mandatoryAwareness,
            subtitle: context.tr.differenceBetweenWasteAndDamage,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
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
                        spacing: 10.h,
                        children: [
                          Text(
                            context
                                .tr
                                .mustPassThisScreenBeforeRegisteringAnyItem,
                            style: AppStyles.s14W400.copyWith(
                              color: AppColors.orange,
                            ),
                          ),
                          const CustomDivider(),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.r,
                              vertical: 16.r,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  context
                                      .tr
                                      .whyDistinguishBetweenWasteAndDamage,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.s14W600.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                                3.verticalSpace,
                                Text(
                                  context
                                      .tr
                                      .toEnsureAccuracyOfFinancialAndOperationalReports,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.s14W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.r,
                              vertical: 16.r,
                            ),
                            child: Column(
                              spacing: 8.h,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 12.w,
                                  children: [
                                    AppSvg(
                                      assetName: AppAssets.trashSvg,
                                      width: 16.r,
                                      colorFilter: ColorFilter.mode(
                                        context.customColor.text3,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 6.h,
                                        children: [
                                          Text(
                                            context.tr.wasteColon,
                                            style: AppStyles.s14W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                          Text(
                                            context
                                                .tr
                                                .productsThatCannotBeUsedDueTo,
                                            style: AppStyles.s13W400.copyWith(
                                              color: context.customColor.text3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: context.customColor.text2,
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.r,
                                    vertical: 16.r,
                                  ),
                                  child: Column(
                                    spacing: 8.h,
                                    children: [
                                      Row(
                                        spacing: 8.w,
                                        children: [
                                          AppSvg(
                                            assetName:
                                                AppAssets.checkWithContainer,
                                            width: 18.r,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.lightGreen,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          Text(
                                            context.tr.correctExamplesOfWaste,
                                            style: AppStyles.s12W600.copyWith(
                                              color: context.customColor.text4,
                                            ),
                                          ),
                                        ],
                                      ),
                                      _dotText(
                                        context: context,
                                        text: context.tr.expirationDatePassed,
                                      ),
                                      _dotText(
                                        context: context,
                                        text: context
                                            .tr
                                            .naturalSpoilageMoldOdorChange,
                                      ),
                                      _dotText(
                                        context: context,
                                        text:
                                            context.tr.excessCookingBeyondNeed,
                                      ),
                                      _dotText(
                                        context: context,
                                        text:
                                            context.tr.foodPreparationLeftovers,
                                      ),
                                      _dotText(
                                        context: context,
                                        text: context
                                            .tr
                                            .productsNearingExpiration,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    border: Border.all(
                                      color: context.customColor.border,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.r,
                                    vertical: 16.r,
                                  ),
                                  child: Column(
                                    spacing: 8.h,
                                    children: [
                                      Row(
                                        spacing: 8.w,
                                        children: [
                                          AppSvg(
                                            assetName: AppAssets.wallet,
                                            width: 18.r,
                                          ),
                                          Text(
                                            context.tr.accountingImpactWaste,
                                            style: AppStyles.s12W600.copyWith(
                                              color: context.customColor.text4,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        context
                                            .tr
                                            .employeeMustBeSelectedCostMayBeDeductedIfManagementRejectsTheJustification,
                                        style: AppStyles.s13W400.copyWith(
                                          color: context.customColor.text4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.r,
                              vertical: 16.r,
                            ),
                            child: Column(
                              spacing: 8.h,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 12.w,
                                  children: [
                                    AppSvg(
                                      assetName: AppAssets.broken,
                                      width: 16.r,
                                      colorFilter: ColorFilter.mode(
                                        context.customColor.text3,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 6.h,
                                        children: [
                                          Text(
                                            context.tr.damages,
                                            style: AppStyles.s14W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                          Text(
                                            context
                                                .tr
                                                .productsDamagedDueToExternalFactors,
                                            style: AppStyles.s13W400.copyWith(
                                              color: context.customColor.text3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: context.customColor.text2,
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.r,
                                    vertical: 16.r,
                                  ),
                                  child: Column(
                                    spacing: 8.h,
                                    children: [
                                      Row(
                                        spacing: 8.w,
                                        children: [
                                          AppSvg(
                                            assetName:
                                                AppAssets.checkWithContainer,
                                            width: 18.r,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.lightGreen,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          Text(
                                            context.tr.correctExamplesOfDamage,
                                            style: AppStyles.s12W600.copyWith(
                                              color: context.customColor.text4,
                                            ),
                                          ),
                                        ],
                                      ),
                                      _dotText(
                                        context: context,
                                        text: context.tr.breakingOrFalling,
                                      ),
                                      _dotText(
                                        context: context,
                                        text: context.tr.refrigerationFailure,
                                      ),
                                      _dotText(
                                        context: context,
                                        text: context.tr.containerLeakage,
                                      ),
                                      _dotText(
                                        context: context,
                                        text: context.tr.damageDuringTransport,
                                      ),
                                      _dotText(
                                        context: context,
                                        text: context
                                            .tr
                                            .manufacturingDefectsFromSupplier,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    border: Border.all(
                                      color: context.customColor.border,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.r,
                                    vertical: 16.r,
                                  ),
                                  child: Column(
                                    spacing: 8.h,
                                    children: [
                                      Row(
                                        spacing: 8.w,
                                        children: [
                                          AppSvg(
                                            assetName: AppAssets.wallet,
                                            width: 18.r,
                                          ),
                                          Text(
                                            context.tr.accountingImpactDamage,
                                            style: AppStyles.s12W600.copyWith(
                                              color: context.customColor.text4,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        context
                                            .tr
                                            .employeeMustBeSelectedCostMayBeDeductedIfManagementRejectsTheJustification,
                                        style: AppStyles.s13W400.copyWith(
                                          color: context.customColor.text4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: context.customColor.text2,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                              vertical: 16.r,
                            ),
                            child: Column(
                              spacing: 8.h,
                              children: [
                                Row(
                                  spacing: 12.w,
                                  children: [
                                    AppSvg(
                                      assetName: AppAssets.warning,
                                      width: 16.r,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.orange,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        context.tr.commonIncorrectExamples,
                                        style: AppStyles.s14W600.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        context.customColor.reversedTextColor,
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.r,
                                    vertical: 16.r,
                                  ),
                                  child: Column(
                                    spacing: 8.h,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context
                                            .tr
                                            .recordingStaffConsumptionAsWasteOrDamage,
                                        style: AppStyles.s13W400.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                      Text(
                                        context
                                            .tr
                                            .hidingCountingShortageAsDamage,
                                        style: AppStyles.s13W400.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                      Text(
                                        context.tr.confusingBetweenTheTwoTerms,
                                        style: AppStyles.s13W400.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  spacing: 8.w,
                                  children: [
                                    AppSvg(
                                      assetName: AppAssets.cameraSvg,
                                      width: 18.r,
                                    ),
                                    Text(
                                      context.tr.documentationRequirements,
                                      style: AppStyles.s12W600.copyWith(
                                        color: context.customColor.text4,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    color:
                                        context.customColor.reversedTextColor,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.r,
                                    vertical: 16.r,
                                  ),
                                  child: Column(
                                    spacing: 8.h,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 3.r,
                                            color: context.customColor.text4,
                                          ),
                                          7.horizontalSpace,
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  context.tr.wasteColon,
                                                  style: AppStyles.s13W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text4,
                                                      ),
                                                ),
                                                5.horizontalSpace,
                                                Expanded(
                                                  child: Text(
                                                    context.tr.photoOptional,
                                                    style: AppStyles.s13W400
                                                        .copyWith(
                                                          color: context
                                                              .customColor
                                                              .text1,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 3.r,
                                            color: context.customColor.text4,
                                          ),
                                          7.horizontalSpace,
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  context.tr.damageColon,
                                                  style: AppStyles.s13W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text4,
                                                      ),
                                                ),
                                                5.horizontalSpace,
                                                Expanded(
                                                  child: Text(
                                                    context
                                                        .tr
                                                        .photoRequiredIfValueGreaterThan20Sar,
                                                    style: AppStyles.s13W400
                                                        .copyWith(
                                                          color: context
                                                              .customColor
                                                              .text1,
                                                        ),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  WastedMandatoryAwarenessConfirmSection(userType: userType),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dotText({required BuildContext context, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.circle, size: 3.r, color: context.customColor.text4),
        7.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text4),
          ),
        ),
      ],
    );
  }
}
