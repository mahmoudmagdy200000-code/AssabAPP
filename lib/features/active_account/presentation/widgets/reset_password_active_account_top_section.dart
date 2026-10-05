import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/change_language_button.dart';

class ResetPasswordActiveAccountTopSection extends StatelessWidget {
  const ResetPasswordActiveAccountTopSection({super.key});

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
            context.tr.activateAccount,
            style: AppStyles.s20W500.copyWith(
              color: context.customColor.reversedTextColor,
            ),
          ),
          16.verticalSpace,
          Text(
            context.tr.accountVerifiedDescription,
            textAlign: TextAlign.center,
            style: AppStyles.s14W400.copyWith(
              color: context.customColor.reversedTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
