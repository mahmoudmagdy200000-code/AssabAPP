import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';

class ExpensesFilterTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  final bool isSelected;

  const ExpensesFilterTextButton({
    super.key,
    required this.text,
    required this.onClick,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onClick,
      child: Container(
        height: 32.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(1000.r),
          border: Border.all(
            color: isSelected
                ? context.theme.primaryColor
                : context.customColor.border,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: AppStyles.s12W400.copyWith(
              color: isSelected
                  ? context.theme.primaryColor
                  : context.customColor.text6,
            ),
          ),
        ),
      ),
    );
  }
}
