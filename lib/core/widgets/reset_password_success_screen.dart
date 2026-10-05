import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/core/widgets/change_language_button.dart';
import 'package:flutter/material.dart';

class ResetPasswordSuccessScreen extends StatelessWidget {
  const ResetPasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: AppPaddingWidget(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ChangeLanguageButton(textColor: context.customColor.text1),
              ],
            ),
            25.verticalSpace,
            AppAssetImage(
              image: AppAssets.anotherLogo,
              width: 124.w,
              height: 88.h,
            ),
            20.verticalSpace,
            AppAssetImage(
              image: AppAssets.resetPassword,
              width: 234.w,
              height: 200.h,
            ),
            16.verticalSpace,
            Text(
              context.tr.passwordResetSuccessful,
              style: AppStyles.s20W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            12.verticalSpace,
            Text(
              context.tr.passwordResetDesc,
              textAlign: TextAlign.center,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            const Spacer(),
            AppButton(
              onClick: () =>
                  NavigationService.I.offAllNamed(AppRouteName.start),
              text: context.tr.logInToMyAccount,
              enabled: true,
              textColor: context.theme.primaryColor,
              isTransparent: true,
              borderColor: context.theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
