import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_button.dart';

class OnboardingBottomSection extends StatelessWidget {
  const OnboardingBottomSection({super.key});

  void _goToActiveAccountScreen() {
    NavigationService.I.pushNamed(AppRouteName.activeAccountScreen);
  }

  void _goToLoginScreen() {
    NavigationService.I.pushNamed(AppRouteName.loginWithEmailScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 24.r),
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.r),
            topRight: Radius.circular(32.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onClick: _goToActiveAccountScreen,
                    enabled: true,
                    isTransparent: true,
                    text: context.tr.activateAccount,
                    textColor: context.customColor.text1,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: AppButton(
                    onClick: _goToLoginScreen,
                    enabled: true,
                    text: context.tr.login,
                  ),
                ),
              ],
            ),
            20.verticalSpace,
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: context.tr.byContinuingYouAgreeToOur,
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text3,
                ),
                children: [
                  TextSpan(
                    text: context.tr.termsOfService,
                    style: AppStyles.s13W500.copyWith(
                      color: context.theme.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: context.tr.and,
                    style: AppStyles.s13W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  TextSpan(
                    text: context.tr.privacyPolicy,
                    style: AppStyles.s13W500.copyWith(
                      color: context.theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
