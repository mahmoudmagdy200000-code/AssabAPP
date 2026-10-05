import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';
import 'app_gesture_detector_button.dart';
import 'app_svg.dart';

class ChooseLanguageButton extends StatelessWidget {
  final VoidCallback changeLanguage;
  final String text;
  final String flag;
  final bool selectedLanguage;

  const ChooseLanguageButton({
    super.key,
    required this.changeLanguage,
    required this.text,
    required this.flag,
    required this.selectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppGestureDetectorButton(
        onTap: changeLanguage,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(1000.r),
            border: Border.all(color: context.customColor.border),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
          child: Row(
            children: [
              AppSvg(assetName: flag, width: 24.r, height: 24.r),
              8.horizontalSpace,
              Text(
                text,
                style: AppStyles.s12W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              const Spacer(),
              Container(
                height: 20.r,
                width: 20.r,
                decoration: BoxDecoration(
                  color: selectedLanguage
                      ? context.theme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(1000.r),
                  border: Border.all(
                    color: context.customColor.border,
                    width: selectedLanguage ? 3.r : 1.r,
                  ),
                ),
                padding: EdgeInsets.all(2.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
