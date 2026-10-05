import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/change_language_button.dart';

class OnboardingAppBar extends StatelessWidget {
  const OnboardingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppAssetImage(image: AppAssets.logo, width: 57.w, height: 32.h),
        const ChangeLanguageButton(),
      ],
    );
  }
}
