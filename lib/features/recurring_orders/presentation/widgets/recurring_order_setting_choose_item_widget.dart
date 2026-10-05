import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/styles/app_styles.dart';

class RecurringOrderSettingChooseItemWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool singleSelection;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final TextAlign? textAlign;

  const RecurringOrderSettingChooseItemWidget({
    super.key,
    required this.text,
    this.isSelected = false,
    this.singleSelection = false,
    this.onTap,
    this.padding,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap ?? () {},
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? context.theme.primaryColor
                : context.customColor.border,
          ),
        ),
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                textAlign: textAlign,
                style: AppStyles.s14W500.copyWith(
                  color: isSelected
                      ? context.theme.primaryColor
                      : context.customColor.text4,
                ),
              ),
            ),
            if (singleSelection) ...[
              10.horizontalSpace,
              SelectionCircule(isSelected: isSelected),
            ],
          ],
        ),
      ),
    );
  }
}
