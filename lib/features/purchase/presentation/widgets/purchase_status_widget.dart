import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';

class PurchaseStatusWidget extends StatelessWidget {
  final Color? backgroundColor;
  final String statusText;
  final Color? textColor;
  final bool withBorder;
  final Color? borderColor;

  const PurchaseStatusWidget({
    super.key,
    this.backgroundColor,
    required this.statusText,
    this.textColor,
    this.withBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.customColor.text2,
        borderRadius: BorderRadius.circular(1000.r),
        border: withBorder
            ? Border.all(color: borderColor ?? context.customColor.border)
            : null,
      ),
      padding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
      child: Text(
        statusText,
        style: AppStyles.s10W500.copyWith(
          color: textColor ?? context.customColor.text4,
        ),
      ),
    );
  }
}
