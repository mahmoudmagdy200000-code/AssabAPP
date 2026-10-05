import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

class TimeLineImage extends StatelessWidget {
  final String? image;

  const TimeLineImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(4.r),
      child: image == null
          ? AppSvg(assetName: AppAssets.personSvg, width: 15.w)
          : AppNetworkImage(
              image: image!,
              width: 15.w,
              borderRadius: BorderRadius.circular(1000.r),
            ),
    );
  }
}
