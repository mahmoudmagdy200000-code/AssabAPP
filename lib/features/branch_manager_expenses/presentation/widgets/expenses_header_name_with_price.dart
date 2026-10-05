import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/price_label.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_divider.dart';

class ExpensesHeaderNameWithPrice extends StatelessWidget {
  final String title;
  final String amount;
  final Color lineColor;
  final bool showUnderLine;

  const ExpensesHeaderNameWithPrice({
    super.key,
    required this.title,
    required this.amount,
    required this.lineColor,
    this.showUnderLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(width: 3.w, height: 20.h, color: lineColor),
            10.horizontalSpace,
            Text(
              title,
              style: AppStyles.s13W400.copyWith(
                color: context.customColor.text1,
              ),
            ),
            const Spacer(),
            PriceLabel(amount: amount),
          ],
        ),
        8.verticalSpace,
        if (showUnderLine) ...[const CustomDivider(), 8.verticalSpace],
      ],
    );
  }
}
