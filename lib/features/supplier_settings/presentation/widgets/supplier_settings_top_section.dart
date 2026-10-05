import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_svg_button.dart';

class SupplierSettingsTopSection extends StatelessWidget {
  const SupplierSettingsTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.customColor.reversedTextColor,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 20.r,
        left: 20.r,
        right: 20.r,
        bottom: 29.r,
      ),
      margin: EdgeInsets.only(top: 8.r, bottom: 8.r),
      child: Column(
        children: [
          Stack(
            children: [
              AppAssetImage(
                image: AppAssets.testProfile,
                width: 100.w,
                height: 100.w,
                borderRadius: BorderRadius.circular(1000.r),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: AppSvgButton(
                  bgColor: context.customColor.reversedTextColor,
                  assetName: AppAssets.edit,
                  iconSize: 14.r,
                  onTap: () {},
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Text(
            getIt<SharedPreferencesHelper>().getString('u_name') ?? '',
            style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          ),
          4.verticalSpace,
          Text(
            context.tr.supplierSettings,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          17.verticalSpace,
          Text(
            'You were added on jan 16, 2025 at 9:31 Am.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text1),
          ),
        ],
      ),
    );
  }
}
