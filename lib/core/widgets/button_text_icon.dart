import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';
import 'app_gesture_detector_button.dart';

class ButtonTextIcon extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Widget icon;
  final bool isTransparent;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? spaceBetweenTextAndIcon;
  final TextStyle? textStyle;
  final bool isFlexible;
  final bool reversed;

  const ButtonTextIcon({
    super.key,
    required this.onTap,
    required this.label,
    required this.icon,
    this.isTransparent = true,
    this.padding,
    this.borderRadius,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    this.spaceBetweenTextAndIcon,
    this.textStyle,
    this.reversed = false,
    this.isFlexible = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              (isTransparent ? Colors.transparent : context.theme.primaryColor),
          borderRadius: borderRadius ?? BorderRadius.circular(20.r),
          border: Border.all(
            color:
                borderColor ??
                (isTransparent
                    ? context.customColor.border
                    : context.theme.primaryColor),
          ),
        ),
        padding:
            padding ?? EdgeInsets.symmetric(vertical: 18.r, horizontal: 19.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!reversed) ...[
              icon,
              spaceBetweenTextAndIcon?.horizontalSpace ?? 3.horizontalSpace,
            ],
            if (!isFlexible)
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style:
                    textStyle ??
                    (AppStyles.s12W400.copyWith(
                      color:
                          textColor ??
                          (isTransparent
                              ? context.customColor.text6
                              : context.customColor.reversedTextColor),
                    )),
              )
            else
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style:
                      textStyle ??
                      (AppStyles.s12W400.copyWith(
                        color:
                            textColor ??
                            (isTransparent
                                ? context.customColor.text6
                                : context.customColor.reversedTextColor),
                      )),
                ),
              ),
            if (reversed) ...[
              spaceBetweenTextAndIcon?.horizontalSpace ?? 3.horizontalSpace,
              icon,
            ],
          ],
        ),
      ),
    );
  }
}
