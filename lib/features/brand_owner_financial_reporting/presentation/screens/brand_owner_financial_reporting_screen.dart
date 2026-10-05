import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_switch_button.dart';
import 'package:flutter/material.dart';

class BrandOwnerFinancialReportingScreen extends StatefulWidget {
  const BrandOwnerFinancialReportingScreen({super.key});

  @override
  State<BrandOwnerFinancialReportingScreen> createState() =>
      _BrandOwnerFinancialReportingScreenState();
}

class _BrandOwnerFinancialReportingScreenState
    extends State<BrandOwnerFinancialReportingScreen> {
  late final ValueNotifier<bool> _showSubDetailsNotifier;

  @override
  void initState() {
    super.initState();

    _showSubDetailsNotifier = ValueNotifier(false);
  }

  @override
  void dispose() {
    _showSubDetailsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppPaddingWidget(
              top: 30.r,
              child: Row(
                children: [
                  const AppBackButton(),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.financialReports,
                          style: AppStyles.s15W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          context.tr.nakheelRestaurantChain,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomDivider(thickness: 5.h),
            AppPaddingWidget(
              top: 15.r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTitle(context, context.tr.coreReports),
                      10.horizontalSpace,
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                context.tr.showSubDetails,
                                style: AppStyles.s14W400.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ),
                            ),
                            10.horizontalSpace,
                            ValueListenableBuilder(
                              valueListenable: _showSubDetailsNotifier,
                              builder: (context, value, child) {
                                return CustomSwitchButton(
                                  value: value,
                                  onChanged: (value) {
                                    _showSubDetailsNotifier.value = value;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  _buildChooseWidget(
                    context: context,
                    title: context.tr.profitAndLossStatement,
                    description: context.tr.detailedFinancialAnalysis,
                    icon: AppAssets.wallet,
                    onTap: () {
                      NavigationService.I.pushNamed(
                        AppRouteName.brandOwnerProfitAndLossStatementScreen,
                      );
                    },
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  _buildChooseWidget(
                    context: context,
                    title: context.tr.salesChannelAnalysis,
                    description: context.tr.comprehensiveChannelAnalysis,
                    icon: AppAssets.cash,
                    onTap: () {
                      NavigationService.I.pushNamed(
                        AppRouteName.brandOwnerSalesChannelAnalysisScreen,
                      );
                    },
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  _buildChooseWidget(
                    context: context,
                    title: context.tr.smartComparisons,
                    description: context.tr.monthlyAndBranchComparisons,
                    icon: AppAssets.viewReports,
                    onTap: () {
                      NavigationService.I.pushNamed(
                        AppRouteName.brandOwnerSmartComparisonsScreen,
                      );
                    },
                  ),
                ],
              ),
            ),
            CustomDivider(thickness: 5.h),
            AppPaddingWidget(
              top: 15.r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context, context.tr.specializedReports),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  _buildChooseWidget(
                    context: context,
                    title: context.tr.profitVsCashReconciliation,
                    description: context
                        .tr
                        .understandTheDifferenceBetweenYourMoneyAndProfits,
                    icon: AppAssets.cash,
                    onTap: () {
                      NavigationService.I.pushNamed(
                        AppRouteName.brandOwnerProfitVsCashReconciliationScreen,
                      );
                    },
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  _buildChooseWidget(
                    context: context,
                    title: context.tr.breakEvenAnalysis,
                    description: context.tr.riskAnalysisAndFinancialSafety,
                    icon: AppAssets.cash,
                    onTap: () {
                      NavigationService.I.pushNamed(
                        AppRouteName.brandOwnerBreakEvenAnalysisScreen,
                      );
                    },
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  _buildChooseWidget(
                    context: context,
                    title: context.tr.operationalProfitability,
                    description:
                        context.tr.performanceIndicatorsAndIndustryComparisons,
                    icon: AppAssets.operationalProfitabilitySvg,
                    onTap: () {
                      NavigationService.I.pushNamed(
                        AppRouteName.brandOwnerOperationalProfitabilityScreen,
                      );
                    },
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  _buildChooseWidget(
                    context: context,
                    title: context.tr.menuEngineering,
                    description:
                        context.tr.performanceIndicatorsAndIndustryComparisons,
                    icon: AppAssets.menuEngineeringSvg,
                    onTap: () {
                      NavigationService.I.pushNamed(
                        AppRouteName.brandOwnerMenuEngineeringScreen,
                      );
                    },
                  ),
                ],
              ),
            ),
            CustomDivider(thickness: 5.h),
            AppPaddingWidget(
              top: 15.r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context, context.tr.menuEngineeringActions),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  _buildChooseWidget(
                    context: context,
                    title: context.tr.itemTest,
                    description:
                        context.tr.testProfitabilityOfNewItemsBeforeAddingThem,
                    icon: AppAssets.itemTestSvg,
                    onTap: () {
                      NavigationService.I.pushNamed(
                        AppRouteName.brandOwnerTestItemScreen,
                      );
                    },
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  _buildChooseWidget(
                    context: context,
                    title: context.tr.pricingSimulator,
                    description:
                        context.tr.simulateTheImpactOfPriceChangesOnProfits,
                    icon: AppAssets.cash,
                    onTap: () {
                      NavigationService.I.pushNamed(
                        AppRouteName.brandOwnerPriceSimulatorScreen,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _buildTitle(BuildContext context, String text) {
    return Text(
      text,
      style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
    );
  }

  Widget _buildChooseWidget({
    required BuildContext context,
    required String title,
    required String description,
    required String icon,
    required VoidCallback onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.customColor.text2,
            ),
            padding: EdgeInsets.all(10.r),
            child: AppSvg(
              assetName: icon,
              colorFilter: ColorFilter.mode(
                context.customColor.text4,
                BlendMode.srcIn,
              ),
              width: 16.r,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.s12W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _showSubDetailsNotifier,
                  builder: (context, value, child) {
                    if (!value) {
                      return const SizedBox.shrink();
                    }

                    return Text(
                      description,
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
