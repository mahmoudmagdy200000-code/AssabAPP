import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_divider.dart';

class QuickCashExpenseDetailsTopSection extends StatelessWidget {
  const QuickCashExpenseDetailsTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.tr.reviewExpenseSummary,
                style: AppStyles.s20W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),
            5.horizontalSpace,
            AppGestureDetectorButton(
              child: AppSvg(
                assetName: AppAssets.edit,
                colorFilter: ColorFilter.mode(
                  context.customColor.text1,
                  BlendMode.srcIn,
                ),
                width: 20.w,
              ),
              onTap: () => NavigationService.I.pop(),
            ),
          ],
        ),
        10.verticalSpace,
        Text(
          context.tr.reviewExpenseSummaryDesc,
          style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
      ],
    );
  }
}
