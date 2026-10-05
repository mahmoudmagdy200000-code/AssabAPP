import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';
import 'app_svg.dart';

class LabelTextField extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool isLabelRequired;
  final bool isLabelOptional;
  final String? appAssetSvg;
  final String? imageUrl;
  final String? pngAssetName;
  final String? customTextOption;
  final Color? labelColor;

  const LabelTextField({
    super.key,
    required this.text,
    this.style,
    this.isLabelRequired = true,
    this.isLabelOptional = false,
    this.appAssetSvg,
    this.imageUrl,
    this.pngAssetName,
    this.customTextOption,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (appAssetSvg != null) ...[
              AppSvg(assetName: appAssetSvg!, width: 20.w, height: 20.h),
              10.horizontalSpace,
            ],

            if (pngAssetName != null) ...[
              AppAssetImage(image: pngAssetName!, width: 20.w, height: 20.h),
              10.horizontalSpace,
            ],

            if (imageUrl != null) ...[
              Image.network(
                imageUrl!,
                width: 20.w,
                height: 20.h,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
              10.horizontalSpace,
            ],

            Flexible(
              child: Text(
                text,
                style:
                    style ??
                    AppStyles.s14W500.copyWith(
                      color: labelColor ?? context.customColor.text1,
                    ),
              ),
            ),
            10.horizontalSpace,
            if (isLabelOptional && !isLabelRequired)
              Text(
                '(${customTextOption ?? context.tr.optional})',
                style: AppStyles.s14W400.copyWith(
                  color: labelColor ?? context.customColor.text3,
                ),
              ),
            if (isLabelRequired)
              Text(
                '*',
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.error,
                ),
              ),
          ],
        ),
        5.verticalSpace,
      ],
    );
  }
}
