import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';

class VatChooseMethodButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String assetName;
  final bool isTransparent;

  const VatChooseMethodButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.assetName,
    this.isTransparent = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppGestureDetectorButton(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isTransparent
                ? Colors.transparent
                : context.theme.primaryColor,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: context.customColor.border),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 13.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSvg(
                assetName: assetName,
                width: 15.w,
                colorFilter: ColorFilter.mode(
                  isTransparent
                      ? context.customColor.text1
                      : context.customColor.reversedTextColor,
                  BlendMode.srcIn,
                ),
              ),
              8.horizontalSpace,
              Text(
                text,
                style: AppStyles.s12W400.copyWith(
                  color: isTransparent
                      ? context.customColor.text1
                      : context.customColor.reversedTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
