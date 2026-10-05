import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';

class PriceLabel extends StatelessWidget {
  final String amount;

  const PriceLabel({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SaudiRiyalSvgWidget(),
        4.horizontalSpace,
        Text(
          amount,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
