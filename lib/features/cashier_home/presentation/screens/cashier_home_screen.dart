import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../widgets/cashier_empty_widget.dart';
import '../widgets/cashier_home_bottom_section.dart';
import '../widgets/cashier_home_top_section.dart';

class CashierHomeScreen extends StatelessWidget {
  const CashierHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CashierHomeTopSection(),
            Container(
              color: context.customColor.text2,
              width: double.infinity,
              padding: EdgeInsets.all(10.r),
              child: Column(
                spacing: 10.h,
                children: [
                  CashierEmptyWidget(
                    image: AppAssets.calendarPng,
                    title: context.tr.noActiveShift,
                    desc: context.tr.noActiveShiftDesc,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.pendingTasks,
                          style: AppStyles.s16W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        10.verticalSpace,
                        AppGestureDetectorButton(
                          onTap: () {
                            NavigationService.I.pushNamed(
                              AppRouteName.cashierNewAssignmentsScreen,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                            ),
                            padding: EdgeInsets.all(12.r),
                            child: Row(
                              spacing: 12.w,
                              children: [
                                AppSvg(
                                  assetName: AppAssets.detailsSvg,
                                  width: 20.r,
                                  colorFilter: ColorFilter.mode(
                                    context.theme.primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.tr.newAssignments,
                                        style: AppStyles.s14W400.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                      4.verticalSpace,
                                      Text(
                                        context.tr.clickToSeeDetails,
                                        style: AppStyles.s12W400.copyWith(
                                          color: context.customColor.text3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppSvg(
                                  assetName: AppAssets.arrowRight,
                                  width: 12.r,
                                  colorFilter: ColorFilter.mode(
                                    context.theme.primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const CashierHomeBottomSection(),
          ],
        ),
      ),
    );
  }
}
