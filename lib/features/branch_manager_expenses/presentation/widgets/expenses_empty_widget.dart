import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:flutter/material.dart';

class ExpensesEmptyWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;

  const ExpensesEmptyWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppAssetImage(image: icon, width: 80.h, height: 80.h),
        27.verticalSpace,
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        16.verticalSpace,
        Text(
          desc,
          textAlign: TextAlign.center,
          style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
        ),
      ],
    );
  }
}
