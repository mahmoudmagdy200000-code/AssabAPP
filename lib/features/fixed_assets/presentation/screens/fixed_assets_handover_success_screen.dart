import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

class FixedAssetsHandoverSuccessScreen extends StatelessWidget {
  const FixedAssetsHandoverSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppAssetImage(
                    image: AppAssets.handoverCompleted,
                    borderRadius: BorderRadius.zero,
                  ),
                  100.verticalSpace,
                  Text(
                    context.tr.handoverCompleted,
                    textAlign: TextAlign.center,
                    style: AppStyles.s20W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    context.tr.handoverCompletedDesc,
                    textAlign: TextAlign.center,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            ),
            12.verticalSpace,
            CustomTextButton(
              text: context.tr.backToAssetDashboard,
              onTap: () => NavigationService.I.popUntil(
                (p1) => p1.settings.name == AppRouteName.fixedAssetsScreen,
              ),
              backgroundColor: context.theme.primaryColor,
              borderRadius: 1000.r,
              borderColor: Colors.transparent,
              textColor: context.customColor.reversedTextColor,
              padding: EdgeInsets.symmetric(vertical: 18.r),
            ),
          ],
        ),
      ),
    );
  }
}
