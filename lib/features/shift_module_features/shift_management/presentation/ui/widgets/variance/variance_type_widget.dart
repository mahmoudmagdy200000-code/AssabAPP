import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_svg.dart';

class VarianceTypeWidget extends StatelessWidget {
  final String label;
  final String assetName;

  const VarianceTypeWidget({
    super.key,
    required this.label,
    required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
        5.horizontalSpace,
        AppSvg(assetName: assetName, width: 20.w),
      ],
    );
  }
}
