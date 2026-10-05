import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback onClick;

  const FilterButton({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.all(10.r),
        child: const AppSvg(assetName: AppAssets.filter),
      ),
    );
  }
}
