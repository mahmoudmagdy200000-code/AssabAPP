import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class BranchManagerGridViewItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconAssetName;
  final int colorHex;
  final VoidCallback onTap;

  const BranchManagerGridViewItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconAssetName,
    required this.colorHex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? Color.alphaBlend(
            Color(colorHex).withValues(alpha: 0.08),
            context.theme.scaffoldBackgroundColor,
          )
        : Color(colorHex);

    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: isDark ? Border.all(color: context.customColor.border) : null,
        ),
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subtitle,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(10.r),
                  child: AppSvg(
                    assetName: iconAssetName,
                    width: 18.w,
                    height: 18.w,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
