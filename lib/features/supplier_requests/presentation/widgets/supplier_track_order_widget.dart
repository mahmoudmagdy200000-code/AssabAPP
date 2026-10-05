import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class SupplierTrackOrderWidget extends StatelessWidget {
  final String assetName;
  final Color? iconColor;
  final String title;
  final String description;
  final bool showButton;
  final VoidCallback? onClick;
  final Widget? sectionAfterDetails;
  final String? textButton;
  final Widget? customSection;

  const SupplierTrackOrderWidget({
    super.key,
    required this.assetName,
    required this.title,
    required this.description,
    this.showButton = false,
    this.onClick,
    this.sectionAfterDetails,
    this.textButton,
    this.iconColor,
    this.customSection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSvg(
                assetName: assetName,
                width: 24.r,
                colorFilter: iconColor != null
                    ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                    : null,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      description,
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    5.verticalSpace,
                    ?sectionAfterDetails,
                  ],
                ),
              ),
            ],
          ),
          ?customSection,
          if (showButton) ...[
            20.verticalSpace,
            AppGestureDetectorButton(
              onTap: onClick ?? () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 12.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textButton ?? '',
                      style: AppStyles.s12W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    5.horizontalSpace,
                    Icon(Icons.keyboard_arrow_down, size: 16.r),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
