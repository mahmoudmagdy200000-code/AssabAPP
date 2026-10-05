import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';

class QuickLinksBottomSheetWidget extends StatelessWidget {
  const QuickLinksBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.quickLinks,
            style: AppStyles.s20W600.copyWith(color: context.customColor.text1),
          ),
          Text(
            context.tr.accessAllPurchasingAndGoodsrelatedActionsInOneView,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          14.verticalSpace,
          const CustomDivider(),
          14.verticalSpace,
          _buildTitle(context, context.tr.newOrder),
          12.verticalSpace,
          _buildQuickLinkItem(
            context: context,
            title: context.tr.outOfStock,
            icon: AppAssets.cart,
            onTap: () {
              NavigationService.I.pop();
              NavigationService.I.pop();
              NavigationService.I.pushNamed(AppRouteName.purchaseScreen);
            },
          ),
          12.verticalSpace,
          _buildTitle(context, context.tr.trackOrders),
          12.verticalSpace,
          _buildQuickLinkItem(
            context: context,
            title: context.tr.pendingOrders,
            icon: AppAssets.requests,
            onTap: () {},
          ),
          12.verticalSpace,
          _buildQuickLinkItem(
            context: context,
            title: context.tr.receiveGoods,
            icon: AppAssets.box,
            onTap: () {},
          ),
          12.verticalSpace,
          _buildQuickLinkItem(
            context: context,
            title: context.tr.returnsManagement,
            icon: AppAssets.returnsManagement,
            onTap: () {},
          ),
          12.verticalSpace,
          _buildTitle(context, context.tr.statisticsanalytics),
          12.verticalSpace,
          _buildQuickLinkItem(
            context: context,
            title: context.tr.supplierAnalysisAndComparison,
            icon: AppAssets.ai,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    return Text(
      title,
      style: AppStyles.s14W600.copyWith(color: context.customColor.text3),
    );
  }

  Widget _buildQuickLinkItem({
    required BuildContext context,
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            AppSvg(
              assetName: icon,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                title,
                softWrap: true,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text4,
                ),
              ),
            ),
            10.horizontalSpace,
            AppSvg(
              assetName: AppAssets.arrowRight,
              colorFilter: ColorFilter.mode(
                context.customColor.text1,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
