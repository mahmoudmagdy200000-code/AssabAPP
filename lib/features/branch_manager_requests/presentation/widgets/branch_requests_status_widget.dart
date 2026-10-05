import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';

class BranchRequestsStatusWidget extends StatelessWidget {
  final String status;
  final Color textColor;
  final Color borderColor;
  final Color? backgroundColor;
  final Widget? icon;

  const BranchRequestsStatusWidget({
    super.key,
    required this.status,
    required this.textColor,
    required this.borderColor,
    this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(20.r),
        color: backgroundColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 4.r),
      child: Row(
        children: [
          ?icon,
          if (icon != null) 5.horizontalSpace,
          Text(status, style: AppStyles.s10W500.copyWith(color: textColor)),
        ],
      ),
    );
  }
}
