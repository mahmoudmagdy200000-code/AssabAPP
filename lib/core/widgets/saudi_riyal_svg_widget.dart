import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

class SaudiRiyalSvgWidget extends StatelessWidget {
  final double? size;
  final Color? color;

  const SaudiRiyalSvgWidget({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return AppSvg(
      assetName: AppAssets.saudiRiyal,
      width: size ?? 20.h,
      height: size ?? 20.h,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
