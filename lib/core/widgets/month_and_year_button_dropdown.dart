import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

class MonthAndYearButtonDropdown extends StatelessWidget {
  final String text;
  final VoidCallback onClick;

  final Color? backgroundColor;

  const MonthAndYearButtonDropdown({
    super.key,
    required this.text,
    required this.onClick,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? context.customColor.text2,
          borderRadius: BorderRadius.circular(1000.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 17.r, vertical: 11.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: AppStyles.s12W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: context.customColor.text1,
            ),
          ],
        ),
      ),
    );
  }
}
