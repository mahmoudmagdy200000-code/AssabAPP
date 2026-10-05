import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';

class WastedInventoryScreen extends StatelessWidget {
  const WastedInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.dailyQuickInventory,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    context.tr.reviewTheDetailsBelowBeforeStartingTheProcess,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Container(
                        width: 5.w,
                        height: 55.h,
                        color: context.theme.primaryColor,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${context.tr.note}💡',
                              style: AppStyles.s14W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            5.verticalSpace,
                            Text(
                              context
                                  .tr
                                  .mandatoryAwarenessScreenWillAppearAfterSelection,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  14.verticalSpace,
                  const CustomDivider(),
                  14.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            AppSvg(
                              assetName: AppAssets.calendar,
                              width: 16.r,
                              colorFilter: ColorFilter.mode(
                                context.customColor.text3,
                                BlendMode.srcIn,
                              ),
                            ),
                            5.horizontalSpace,
                            Text(
                              context.tr.thisMonthSoFarMonth('June 2024'),
                              style: AppStyles.s14W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            color: context.customColor.reversedTextColor,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            children: [
                              _buildRow(
                                context: context,
                                title: context.tr.totalWaste,
                                value: '150',
                                isCurrency: true,
                              ),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: context.tr.totalDamage,
                                value: '75',
                                isCurrency: true,
                              ),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: context.tr.numberOfIncidents,
                                value: context.tr.countOfIncidents(12),
                              ),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: context.tr.savedDrafts,
                                value: context.tr.countOfDraft(1),
                              ),
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        Row(
                          children: [
                            AppSvg(
                              assetName: AppAssets.viewReports,
                              width: 16.r,
                              colorFilter: ColorFilter.mode(
                                context.customColor.text3,
                                BlendMode.srcIn,
                              ),
                            ),
                            5.horizontalSpace,
                            Text(
                              context.tr.comparisonWithPreviousMonth,
                              style: AppStyles.s14W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            color: context.customColor.reversedTextColor,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            spacing: 8.h,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          context.tr.wastes,
                                          style: AppStyles.s13W400.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      const AppSvg(
                                        assetName: AppAssets.greenOver,
                                      ),
                                      5.horizontalSpace,
                                      Text(
                                        '15%',
                                        style: AppStyles.s12W500.copyWith(
                                          color: AppColors.lightGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  6.verticalSpace,
                                  Text(
                                    context.tr.decreaseFromLastHour
                                        .toUpperCase(),
                                    style: AppStyles.s10W600.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          context.tr.damages,
                                          style: AppStyles.s13W400.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      const AppSvg(
                                        assetName: AppAssets.redShort,
                                      ),
                                      5.horizontalSpace,
                                      Text(
                                        '8%',
                                        style: AppStyles.s12W500.copyWith(
                                          color: context.customColor.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                  6.verticalSpace,
                                  Text(
                                    context.tr.increaseFromLastHour
                                        .toUpperCase(),
                                    style: AppStyles.s10W600.copyWith(
                                      color: context.customColor.text1,
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
            20.verticalSpace,
            AppButton(
              onClick: () {
                NavigationService.I.pushNamed(
                  AppRouteName.wastedInventoryChooseInventoryMethodScreen,
                );
              },
              text: context.tr.wasteAndDamageRegistration,
              enabled: true,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String title,
    required String value,
    bool isCurrency = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        5.horizontalSpace,
        if (isCurrency) const SaudiRiyalSvgWidget(),
        2.horizontalSpace,
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
