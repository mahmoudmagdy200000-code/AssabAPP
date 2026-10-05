import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/button_text_icon.dart';

import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class FixedAssetsSearchHeaderWidget extends StatelessWidget {
  const FixedAssetsSearchHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: context.customColor.text2)),
      ),
      child: Column(
        children: [
          Row(
            spacing: 12.w,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: AppAssetImage(image: AppAssets.darkLogo, width: 57.r),
              ),
              ButtonTextIcon(
                onTap: () {
                  NavigationService.I.pop();
                },
                label: context.tr.cancel,
                icon: Icon(
                  Icons.close,
                  size: 14.r,
                  color: context.customColor.text1,
                ),
                backgroundColor: context.customColor.text2,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                spaceBetweenTextAndIcon: 7.w,
              ),
            ],
          ),
          10.verticalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    context.tr.smartAssetSearch,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  AppSvg(assetName: AppAssets.ai, width: 20.r, height: 20.r),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                '84 ${context.tr.assetsInYourBranch}',
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
