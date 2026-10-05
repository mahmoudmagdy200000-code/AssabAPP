import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../styles/app_styles.dart';
import 'app_asset_image.dart';
import 'app_padding_widget.dart';
import 'change_language_button.dart';

class TopSectionAuthWidget extends StatelessWidget {
  final String title;
  final String desc;

  const TopSectionAuthWidget({
    super.key,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [ChangeLanguageButton()],
          ),
          12.verticalSpace,
          AppAssetImage(image: AppAssets.logo, width: 57.w, height: 32.h),
          16.verticalSpace,
          Text(
            title,
            style: AppStyles.s20W500.copyWith(
              color: context.customColor.reversedTextColor,
            ),
          ),
          16.verticalSpace,
          Text(
            desc,
            textAlign: TextAlign.center,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text2),
          ),
        ],
      ),
    );
  }
}
