import 'package:flutter/material.dart';

import '../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../../core/widgets/app_svg.dart';

class SvgWithTitleCellWidget extends StatelessWidget {
  final String title;
  final String svgAssetName;

  const SvgWithTitleCellWidget({
    super.key,
    required this.title,
    required this.svgAssetName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSvg(assetName: svgAssetName),
        4.horizontalSpace,

        Expanded(child: Text(title, style: AppStyles.s12W500, softWrap: true)),
      ],
    );
  }
}
