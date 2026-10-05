import 'package:flutter/material.dart';

import '../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../core/styles/app_colors.dart';

class FinalDailyCloseTableCellWidget extends StatelessWidget {
  final Color? cellColor;
  final Widget child;
  final double topStartBorderRadius;
  final double topEndBorderRadius;
  final double bottomStartBorderRadius;
  final double bottomEndBorderRadius;
  final BorderSide topBorderSide;
  final BorderSide bottomBorderSide;
  final BorderSide startBorderSide;
  final BorderSide endBorderSide;

  const FinalDailyCloseTableCellWidget({
    super.key,
    required this.child,
    this.cellColor,
    this.topStartBorderRadius = 0,
    this.topEndBorderRadius = 0,
    this.bottomStartBorderRadius = 0,
    this.bottomEndBorderRadius = 0,
    this.topBorderSide = BorderSide.none,
    this.bottomBorderSide = BorderSide.none,
    this.startBorderSide = BorderSide.none,
    this.endBorderSide = BorderSide.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      width: 90.w,
      alignment: Alignment.center,
      padding: EdgeInsetsDirectional.only(start: 10.w),
      decoration: BoxDecoration(
        border: BorderDirectional(
          top: topBorderSide,
          bottom: bottomBorderSide,
          start: startBorderSide,
          end: endBorderSide,
        ),
        color: cellColor ?? AppColors.lightBackground,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(topStartBorderRadius),
          topEnd: Radius.circular(topEndBorderRadius),
          bottomStart: Radius.circular(bottomStartBorderRadius),
          bottomEnd: Radius.circular(bottomEndBorderRadius),
        ),
      ),
      child: child,
    );
  }
}
