import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import 'app_svg.dart';
import 'button_text_icon.dart';

class EditAndResubmitButton extends StatelessWidget {
  const EditAndResubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonTextIcon(
      onTap: () {},
      label: 'Edit & Re-submit',
      icon: AppSvg(
        assetName: AppAssets.edit,
        width: 18.r,
        colorFilter: ColorFilter.mode(
          context.customColor.reversedTextColor,
          BlendMode.srcIn,
        ),
      ),
      spaceBetweenTextAndIcon: 8.r,
      backgroundColor: context.theme.primaryColor,
      textColor: context.customColor.reversedTextColor,
    );
  }
}
