import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class SupplierSettingsSystemSettingsItemWidget extends StatelessWidget {
  final String assetName;
  final String title;
  final VoidCallback onTap;
  final String? selectedValue;
  final Widget? customIcon;

  const SupplierSettingsSystemSettingsItemWidget({
    super.key,
    required this.assetName,
    required this.title,
    required this.onTap,
    this.selectedValue,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.r),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.customColor.border)),
      ),
      child: Row(
        children: [
          AppSvg(assetName: assetName, width: 20.r, height: 20.r),
          12.horizontalSpace,
          Text(
            title,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          const Spacer(),
          AppGestureDetectorButton(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(13.r),
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 11.5.r),
              child: Row(
                children: [
                  if (customIcon != null) ...[customIcon!, 10.horizontalSpace],
                  Text(
                    selectedValue ?? context.tr.systemPreference,
                    style: AppStyles.s11W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  7.horizontalSpace,
                  Icon(Icons.keyboard_arrow_down_outlined, size: 15.r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
