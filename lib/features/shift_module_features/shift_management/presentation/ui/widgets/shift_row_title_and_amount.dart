import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/widgets/app_svg.dart';
import '../../../../../../core/widgets/saudi_riyal_svg_widget.dart';

class ShiftRowTitleAndAmount extends StatelessWidget {
  final String title;
  final String? amount;
  final bool showCurrencySymbol;
  final Widget? widget;
  final TextStyle? titleStyle;

  const ShiftRowTitleAndAmount({
    super.key,
    required this.title,
    this.amount,
    this.widget,
    this.showCurrencySymbol = true,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppSvg(assetName: AppAssets.cash, width: 14.w),
        8.horizontalSpace,
        Text(
          title,
          style:
              titleStyle ??
              AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        const Spacer(),
        if (showCurrencySymbol) const SaudiRiyalSvgWidget(),
        widget ??
            Text(
              amount ?? '',
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
      ],
    );
  }
}
