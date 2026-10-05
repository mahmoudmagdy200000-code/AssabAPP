import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/app_svg_button.dart';
import '../../../../core/widgets/button_text_icon.dart';

class BranchManagerSettingsTopSection extends StatelessWidget {
  final UserTypeStrategy userType;

  const BranchManagerSettingsTopSection({super.key, required this.userType});

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
            getIt<SharedPreferencesHelper>().getString('u_name') ?? '-',
            style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          ),
          4.verticalSpace,
          // Text(
          //   context.tr.branchManagerSettings,
          //   style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          // ),
          if (userType is BranchManagerUserStrategy) ...[
            12.verticalSpace,
            ButtonTextIcon(
              onTap: () {
                NavigationService.I.pushNamed(
                  AppRouteName.branchManagerSettingAndAggregatorsScreen,
                );
              },
              backgroundColor: context.theme.primaryColor,
              borderRadius: BorderRadius.circular(1000.r),
              padding: EdgeInsets.symmetric(vertical: 15.r, horizontal: 19.r),
              label: context.tr.branchSettingsAggregators,
              textStyle: AppStyles.s13W500.copyWith(
                color: context.customColor.reversedTextColor,
              ),
              icon: const AppSvg(assetName: AppAssets.tool),
            ),
          ],
          // 17.verticalSpace,
          // Text(
          //   'You were added on jan 16, 2025 at 9:31 Am.',
          //   style: AppStyles.s13W400.copyWith(color: context.customColor.text1),
          // ),
        ],
      ),
    );
  }
}
