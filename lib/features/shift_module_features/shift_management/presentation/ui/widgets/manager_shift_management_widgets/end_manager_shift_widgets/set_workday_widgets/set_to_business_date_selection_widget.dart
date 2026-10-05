import 'package:flutter/material.dart';

import '../../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../../../core/widgets/selection_circule.dart';

class SetToBusinessDateSelectionWidget extends StatelessWidget {
  const SetToBusinessDateSelectionWidget({
    super.key,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String subtitle;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: AppColors.primaryLight, width: 1.w)
              : null,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.setBusinessDateTo,
                  style: AppStyles.s15W500.copyWith(
                    color: isSelected
                        ? AppColors.primaryLight
                        : context.customColor.text1,
                  ),
                ),

                5.verticalSpace,
                Row(
                  children: [
                    AppSvg(
                      assetName: AppAssets.calendar,
                      width: 20.w,
                      height: 20.h,
                    ),
                    5.horizontalSpace,

                    Text(
                      subtitle,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text4,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SelectionCircule(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}
