import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';

class CashierEmptyWidget extends StatelessWidget {
  final String title;
  final String desc;
  final String image;

  const CashierEmptyWidget({
    super.key,
    required this.title,
    required this.desc,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(40.r),
      child: Column(
        spacing: 16.h,
        children: [
          AppAssetImage(
            image: image,
            width: 80.r,
            borderRadius: BorderRadius.zero,
          ),
          Text(
            title,
            style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          Text(
            desc,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
