import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extensions.dart';
import '../../core/extensions/number_extensions.dart';
import '../../core/styles/app_styles.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onClick;
  final String text;
  final Color? background;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final bool enabled;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets? padding;
  final bool isTransparent;
  final bool isFlexible;
  final Widget? icon;

  const AppButton({
    super.key,
    required this.onClick,
    required this.text,
    this.background,
    this.textColor,
    this.borderColor,
    this.width,
    this.enabled = false,
    this.borderRadius,
    this.padding,
    this.isTransparent = false,
    this.isFlexible = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onClick : null,
        style: ButtonStyle(
          enableFeedback: false,
          elevation: const WidgetStatePropertyAll(0),
          side: isTransparent
              ? WidgetStatePropertyAll(
                  BorderSide(color: borderColor ?? context.customColor.border),
                )
              : null,
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(1000.r),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(
            isTransparent
                ? Colors.transparent
                : enabled
                ? (background ?? context.theme.primaryColor)
                : (background ?? context.customColor.text2),
          ),
          padding: WidgetStatePropertyAll(
            padding ?? EdgeInsets.symmetric(vertical: 17.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ?icon,
            if (icon != null) 7.horizontalSpace,
            if (isFlexible) ...[
              Flexible(
                child: Text(
                  text,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppStyles.s14W400.copyWith(
                    color: !enabled
                        ? (textColor ?? context.customColor.text3)
                        : textColor ??
                              (isTransparent
                                  ? context.customColor.text1
                                  : context.customColor.reversedTextColor),
                  ),
                ),
              ),
            ] else ...[
              Text(
                text,
                style: AppStyles.s14W400.copyWith(
                  color: !enabled
                      ? (textColor ?? context.customColor.text3)
                      : textColor ??
                            (isTransparent
                                ? context.customColor.text1
                                : context.customColor.reversedTextColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
