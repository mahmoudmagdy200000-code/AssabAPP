import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

class TodaySummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final String assetName;

  const TodaySummaryRow({
    super.key,
    required this.title,
    required this.value,
    required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppSvg(assetName: assetName, width: 16.r, height: 16.r),
        10.horizontalSpace,
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
