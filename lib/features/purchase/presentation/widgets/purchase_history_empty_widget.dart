import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_text_button.dart';

class PurchaseHistoryEmptyWidget extends StatelessWidget {
  const PurchaseHistoryEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(8.r),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 40.r, horizontal: 40.r),
            child: Column(
              children: [
                AppAssetImage(
                  image: AppAssets.boxPNG,
                  width: 90.w,
                  height: 100.w,
                  borderRadius: BorderRadius.zero,
                ),
                16.verticalSpace,
                Text(
                  context.tr.noApprovedOrdersYet,
                  textAlign: TextAlign.center,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                16.verticalSpace,
                Text(
                  context.tr.noneOfYourRequestsHaveBeenApprovedYet,
                  textAlign: TextAlign.center,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                25.verticalSpace,
                Text(
                  context.tr.keepAnEyeOutForUpdatesOrStartANew,
                  textAlign: TextAlign.center,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 15.r),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.pendingOrders,
                    onTap: () {},
                    padding: EdgeInsets.symmetric(
                      vertical: 18.r,
                      horizontal: 19.r,
                    ),
                    borderRadius: 17.r,
                    textColor: context.customColor.text4,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: ButtonTextIcon(
                    onTap: () {
                      NavigationService.I.pop();
                      NavigationService.I.pushNamed(
                        AppRouteName.purchaseScreen,
                      );
                    },
                    label: context.tr.newOrder,
                    icon: AppSvg(
                      assetName: AppAssets.cart,
                      colorFilter: ColorFilter.mode(
                        context.customColor.reversedTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 18.r,
                      horizontal: 19.r,
                    ),
                    borderRadius: BorderRadius.circular(17.r),
                    textColor: context.customColor.reversedTextColor,
                    backgroundColor: context.theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
