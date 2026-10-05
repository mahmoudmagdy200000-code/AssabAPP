import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/extensions/number_extensions.dart';
import '../../core/widgets/app_placeholder.dart';

class AppSvg extends StatelessWidget {
  final String assetName;

  final double? width;

  final double? height;

  final ColorFilter? colorFilter;

  final BoxFit fit;

  const AppSvg({
    super.key,
    required this.assetName,
    this.width,
    this.height,
    this.colorFilter,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: fit,
      colorFilter: colorFilter,
      placeholderBuilder: (context) =>
          AppPlaceholder(width: width ?? 20.r, height: height ?? 20.r),
    );
  }
}
