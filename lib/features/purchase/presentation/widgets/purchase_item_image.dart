import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_svg.dart';

class PurchaseItemImage extends StatelessWidget {
  final String? image;
  final Color? bgColor;
  final double? size;

  const PurchaseItemImage({super.key, this.bgColor, this.image, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? context.customColor.text2,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(10.r),
      child: image != null
          ? AppNetworkImage(
              image: image!,
              width: size ?? 20.w,
              height: size ?? 20.w,
              borderRadius: BorderRadius.circular(1000.r),
            )
          : AppSvg(
              assetName: AppAssets.imagePlaceholderSvg,
              width: size ?? 20.w,
              height: size ?? 20.w,
            ),
    );
  }
}
