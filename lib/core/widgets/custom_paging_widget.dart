import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

class CustomPagingWidget extends StatelessWidget {
  final bool condition;
  final String text;
  final EdgeInsets? padding;
  final BorderRadiusGeometry? borderRadius;
  final Decoration? decoration;

  const CustomPagingWidget({
    super.key,
    required this.condition,
    required this.text,
    this.padding,
    this.borderRadius,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          decoration ??
          BoxDecoration(
            color: Colors.transparent,
            borderRadius: borderRadius ?? BorderRadius.circular(1000.r),
            border: condition
                ? Border.all(color: context.customColor.text2)
                : null,
          ),
      padding: padding ?? EdgeInsets.all(10.r),
      child: Center(
        child: Text(
          text,
          style: AppStyles.s10W400.copyWith(color: context.customColor.text3),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
