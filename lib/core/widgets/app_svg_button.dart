import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

class AppSvgButton extends StatelessWidget {
  final String assetName;
  final VoidCallback onTap;
  final Color? iconColor;
  final double? iconSize;
  final Color? bgColor;
  final Color? borderColor;
  final bool withBorder;
  final EdgeInsetsGeometry? padding;

  const AppSvgButton({
    super.key,
    required this.assetName,
    required this.onTap,
    this.iconColor,
    this.iconSize,
    this.bgColor,
    this.borderColor,
    this.withBorder = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ?? Colors.transparent,
          shape: BoxShape.circle,
          border: withBorder
              ? Border.all(color: borderColor ?? context.customColor.border)
              : null,
        ),
        padding: padding ?? EdgeInsets.all(8.r),
        child: AppSvg(
          assetName: assetName,
          width: iconSize ?? 16.r,
          height: iconSize ?? 16.r,
          colorFilter: ColorFilter.mode(
            iconColor ?? context.theme.primaryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
