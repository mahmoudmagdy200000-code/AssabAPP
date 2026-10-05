import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extensions.dart';
import '../../core/extensions/number_extensions.dart';
import 'app_gesture_detector_button.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final double? padding;
  final Color? borderColor;
  final double? borderRadius;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.padding,
    this.borderColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AppGestureDetectorButton(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(padding ?? 8.r),
          decoration: BoxDecoration(
            color: backgroundColor ?? context.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 1000.r),
            border: Border.all(color: borderColor ?? Colors.transparent),
          ),
          child: Icon(
            icon,
            size: size ?? 26.r,
            color: iconColor ?? context.theme.primaryColor,
          ),
        ),
      ),
    );
  }
}
