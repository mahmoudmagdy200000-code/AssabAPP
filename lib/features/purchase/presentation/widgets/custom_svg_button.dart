import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';

class CustomSvgButton extends StatelessWidget {
  final VoidCallback onTap;
  final String assetName;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;

  const CustomSvgButton({
    super.key,
    required this.onTap,
    required this.assetName,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        width: 35.w,
        height: 35.w,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor ?? context.customColor.border),
        ),
        padding: EdgeInsets.all(10.r),
        child: AppSvg(
          assetName: assetName,
          width: 16.r,
          colorFilter: ColorFilter.mode(
            iconColor ?? context.customColor.text1,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
