import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';

class AppCheckBox extends StatelessWidget {
  final Color? unselectedColor;
  final Color? selectedColor;
  final Color? checkIconColor;
  final ValueChanged<bool> onChanged;
  final bool value;

  const AppCheckBox({
    super.key,
    this.unselectedColor,
    this.selectedColor,
    this.checkIconColor,
    required this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        decoration: BoxDecoration(
          color: value
              ? (selectedColor ?? context.theme.primaryColor)
              : (unselectedColor ??
                    context.customColor.text3.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(5.r),
        ),
        padding: EdgeInsets.all(3.r),
        child: Icon(
          Icons.check,
          color: checkIconColor ?? context.customColor.reversedTextColor,
          size: 12.r,
        ),
      ),
    );
  }
}
