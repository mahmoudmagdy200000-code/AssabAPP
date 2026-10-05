import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/features/branch_manager_home/presentation/widgets/today_summary_row.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_divider.dart';
import 'branch_manager_action_button.dart';

class BranchManagerHomeMiddleSection extends StatelessWidget {
  const BranchManagerHomeMiddleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.customColor.text2,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
            padding: EdgeInsets.all(25.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr.todaysSummary,
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    Text(
                      'Monday jun 16, 2025',
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                const CustomDivider(),
                8.verticalSpace,
                TodaySummaryRow(
                  assetName: AppAssets.box,
                  title: context.tr.ordersInProgress,
                  value: '5',
                ),
                10.verticalSpace,
                TodaySummaryRow(
                  assetName: AppAssets.receipt,
                  title: context.tr.todaysReceipt,
                  value: '2',
                ),
                32.verticalSpace,
                AppGestureDetectorButton(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: context.theme.primaryColor),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 15.r,
                      horizontal: 19.r,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.tr.goToStocks,
                          style: AppStyles.s12W400.copyWith(
                            color: context.theme.primaryColor,
                          ),
                        ),
                        10.horizontalSpace,
                        AppSvg(
                          assetName: AppAssets.arrowRight,
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
          Container(
            margin: EdgeInsets.only(left: 8.r, right: 8.r, bottom: 10.r),
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 21.r),
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BranchManagerActionButton(
                  assetName: AppAssets.cart,
                  label: context.tr.newOrder,
                  onTap: () => NavigationService.I.pushNamed(
                    AppRouteName.purchaseScreen,
                  ),
                ),
                BranchManagerActionButton(
                  assetName: AppAssets.transfer,
                  label: context.tr.transfershandover,
                  onTap: () {},
                ),
                BranchManagerActionButton(
                  assetName: AppAssets.box,
                  label: context.tr.receiveGoods,
                  onTap: () {
                    NavigationService.I.pushNamed(
                      AppRouteName.receiveGoodsScreen,
                    );
                  },
                ),
                BranchManagerActionButton(
                  assetName: AppAssets.viewReports,
                  label: context.tr.viewReports,
                  onTap: () {
                    NavigationService.I.pushNamed(
                      AppRouteName.branchManagerViewReportsScreen,
                    );
                  },
                ),
                BranchManagerActionButton(
                  assetName: AppAssets.more,
                  label: context.tr.moreActions,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
