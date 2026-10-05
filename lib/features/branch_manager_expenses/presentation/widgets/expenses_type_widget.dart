import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../domain/strategies/expenses_strategy.dart';

class ExpensesTypeWidget extends StatelessWidget {
  final ExpensesStrategy expensesStrategy;
  final VoidCallback onClick;

  const ExpensesTypeWidget({
    super.key,
    required this.expensesStrategy,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.all(16.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSvg(assetName: expensesStrategy.assetName, width: 20.w),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expensesStrategy.displayName(context),
                          style: AppStyles.s13W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          expensesStrategy.description(context),
                          softWrap: true,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            16.horizontalSpace,
            AppSvg(
              assetName: AppAssets.arrowRight,
              colorFilter: ColorFilter.mode(
                context.customColor.text1,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
