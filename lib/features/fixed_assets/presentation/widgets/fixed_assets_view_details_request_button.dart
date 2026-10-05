import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:flutter/material.dart';

class FixedAssetsViewDetailsRequestButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FixedAssetsViewDetailsRequestButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTextIcon(
      onTap: onPressed,
      label: context.tr.viewDetails,
      icon: AppSvg(
        assetName: AppAssets.eye,
        colorFilter: ColorFilter.mode(
          context.customColor.text1,
          BlendMode.srcIn,
        ),
        width: 16.w,
      ),
      spaceBetweenTextAndIcon: 7,
      padding: EdgeInsets.symmetric(vertical: 11.r),
      borderRadius: BorderRadius.circular(1000.r),
    );
  }
}
