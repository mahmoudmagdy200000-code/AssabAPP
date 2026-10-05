import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class BranchManagerAccountAndPasswordItemWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String iconAssetName;
  final String title;
  final ColorFilter? iconColor;

  const BranchManagerAccountAndPasswordItemWidget({
    super.key,
    required this.onTap,
    required this.iconAssetName,
    required this.title,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.r),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.customColor.border)),
        ),
        child: Row(
          children: [
            AppSvg(
              assetName: iconAssetName,
              width: 20.r,
              height: 20.r,
              colorFilter: iconColor,
            ),
            12.horizontalSpace,
            Text(
              title,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            const Spacer(),
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
