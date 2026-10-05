import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';

class ExpensesFilterWidgetTextTitle extends StatelessWidget {
  final String text;

  const ExpensesFilterWidgetTextTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        16.verticalSpace,
        Text(
          text,
          style: AppStyles.s14W500.copyWith(color: context.customColor.text3),
        ),
        8.verticalSpace,
      ],
    );
  }
}
