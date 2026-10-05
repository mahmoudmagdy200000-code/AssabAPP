import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final VoidCallback onTap;

  const EditButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: AppSvg(assetName: AppAssets.edit, width: 16.w),
    );
  }
}
