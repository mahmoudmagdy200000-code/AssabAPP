import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';

class ExpenseSummaryRowWidget extends StatelessWidget {
  final String title;
  final String value;
  final bool showAmountIcon;

  const ExpenseSummaryRowWidget({
    super.key,
    required this.title,
    required this.value,
    this.showAmountIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
        ),
        10.horizontalSpace,
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            children: [
              if (showAmountIcon) const SaudiRiyalSvgWidget(),
              Text(
                value,
                style: AppStyles.s14W500.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
