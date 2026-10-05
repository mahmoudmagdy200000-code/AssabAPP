import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extensions.dart';
import '../../core/extensions/number_extensions.dart';
import '../../core/services/navigation/navigation_service.dart';
import 'app_gesture_detector_button.dart';

class AppBackButton extends StatelessWidget {
  final bool isTransparent;
  final Color? iconColor;

  const AppBackButton({super.key, this.isTransparent = false, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () {
        final navigator = NavigationService.I;

        if (navigator.canPop()) {
          navigator.pop();
        }
      },
      child: Container(
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: isTransparent
              ? Colors.transparent
              : context.customColor.reversedTextColor,
          shape: BoxShape.circle,
          border: isTransparent
              ? Border.all(color: context.customColor.border)
              : null,
        ),
        child: AppSvg(
          assetName: AppAssets.arrowLeft,
          width: 10.r,
          height: 10.r,
          colorFilter: ColorFilter.mode(
            iconColor ??
                (isTransparent
                    ? context.customColor.reversedTextColor
                    : context.customColor.text1),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
