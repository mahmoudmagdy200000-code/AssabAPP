import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';

class ReceiveGoodsEmptyWidget extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const ReceiveGoodsEmptyWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppAssetImage(image: image, width: 80.r, height: 80.r),
        16.verticalSpace,
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        16.verticalSpace,
        Text(
          description,
          textAlign: TextAlign.center,
          style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
        ),
      ],
    );
  }
}
