import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg_button.dart';

class BranOwnerHomeTopSection extends StatelessWidget {
  const BranOwnerHomeTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 30.r,
      bottom: 14.r,
      child: Row(
        children: [
          AppAssetImage(
            image: AppAssets.testProfile,
            width: 40.w,
            height: 40.w,
            borderRadius: BorderRadius.circular(1000.r),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${context.tr.welcome} ${getIt<SharedPreferencesHelper>().getString('u_name')}',
                        style: AppStyles.s16W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Icon(
                      Icons.waving_hand_rounded,
                      size: 15.r,
                      color: const Color(0xffdab194),
                    ),
                  ],
                ),
                Text(
                  context.tr.storeOwnerDashboard,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          AppSvgButton(
            assetName: AppAssets.notification,
            onTap: () {},
            iconColor: context.customColor.text3,
          ),
        ],
      ),
    );
  }
}
