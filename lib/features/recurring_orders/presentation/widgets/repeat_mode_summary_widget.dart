import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class RepeatModeSummaryWidget extends StatelessWidget {
  final String text;

  const RepeatModeSummaryWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(
            assetName: AppAssets.calendar,
            width: 15.r,
            colorFilter: ColorFilter.mode(
              context.theme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.repeatMode,
                  style: AppStyles.s14W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                4.verticalSpace,
                Text(
                  text,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
