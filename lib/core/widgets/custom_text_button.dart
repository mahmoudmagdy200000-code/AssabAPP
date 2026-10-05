import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? textStyle;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.borderColor,
    this.textColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          border: Border.all(color: borderColor ?? context.customColor.border),
        ),
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 10.r, vertical: 11.r),
        child: Center(
          child: Text(
            text,
            style:
                textStyle ??
                AppStyles.s12W500.copyWith(
                  color: textColor ?? context.theme.primaryColor,
                ),
          ),
        ),
      ),
    );
  }
}
