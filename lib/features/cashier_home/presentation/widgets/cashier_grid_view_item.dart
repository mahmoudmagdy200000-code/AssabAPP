import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class CashierGridViewItem extends StatelessWidget {
  final String title;
  // final String subtitle;
  final String iconAssetName;
  final int colorHex;
  final VoidCallback onTap;
  final Color? iconColor;

  const CashierGridViewItem({
    super.key,
    required this.title,
    // required this.subtitle,
    required this.iconAssetName,
    required this.colorHex,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(colorHex),
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                // Text(
                //   subtitle,
                //   style: AppStyles.s14W400.copyWith(
                //     color: context.customColor.text3,
                //   ),
                // ),
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
                    colorFilter: iconColor != null
                        ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                        : null,
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
