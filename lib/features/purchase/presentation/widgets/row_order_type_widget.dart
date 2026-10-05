import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class RowOrderTypeWidget extends StatelessWidget {
  final String assetName;
  final String title;

  const RowOrderTypeWidget({
    super.key,
    required this.assetName,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppSvg(
          assetName: assetName,
          width: 14.w,
          height: 14.w,
          colorFilter: ColorFilter.mode(
            context.customColor.text3,
            BlendMode.srcIn,
          ),
        ),
        5.horizontalSpace,
        Expanded(
          child: Text(
            title,
            softWrap: true,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
        ),
      ],
    );
  }
}
