import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';

class TopSectionOfSingleExpenseViews extends StatelessWidget {
  final String title;
  final String desc;

  const TopSectionOfSingleExpenseViews({
    super.key,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.s20W600.copyWith(color: context.customColor.text1),
        ),
        10.verticalSpace,
        Text(
          desc,
          style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
        ),
        14.verticalSpace,
        const CustomDivider(),
        14.verticalSpace,
      ],
    );
  }
}
