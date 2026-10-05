import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

class ChooseVarianceReasonWidget extends StatelessWidget {
  final String assetName;
  final String title;
  final String desc;
  final VoidCallback onTap;

  const ChooseVarianceReasonWidget({
    super.key,
    required this.assetName,
    required this.title,
    required this.desc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(assetName: assetName, width: 26.w),
          16.horizontalSpace,
          Expanded(
            child: Row(
              children: [
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
                      8.verticalSpace,
                      Text(
                        desc,
                        softWrap: true,
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                24.horizontalSpace,
                AppSvg(
                  assetName: AppAssets.arrowRight,
                  colorFilter: ColorFilter.mode(
                    context.customColor.text1,
                    BlendMode.srcIn,
                  ),
                  width: 24.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
