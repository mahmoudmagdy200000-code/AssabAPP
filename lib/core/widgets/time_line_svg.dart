import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import 'app_svg.dart';

class TimeLineSvg extends StatelessWidget {
  final String assetName;
  final Color? color;

  const TimeLineSvg({super.key, required this.assetName, this.color});

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
      child: AppSvg(
        assetName: assetName,
        width: 15.w,
        colorFilter: ColorFilter.mode(
          color ?? context.customColor.text1,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
