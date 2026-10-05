import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/navigation/navigation_service.dart'
    show NavigationService;
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_text_button.dart';

class InventoryHowToSliderWorkScreen extends StatelessWidget {
  const InventoryHowToSliderWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 50.r,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.howSliderWorks,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    context.tr.useSliderToEstimateHowFull,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  16.verticalSpace,
                  const CustomDivider(),
                  16.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: AppAssetImage(image: AppAssets.bottlesPng),
                      ),
                      24.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.firstEnterFullVolumeOfOneItem,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text4,
                              ),
                            ),
                            15.verticalSpace,
                            Text(
                              context.tr.thenUseSliderToShowHowMuchLeft,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text4,
                              ),
                            ),
                            15.verticalSpace,
                            Text(
                              context.tr.sliderHelpsWhenNotAllContainersFull,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  const CustomDivider(),
                  16.verticalSpace,
                  Row(
                    children: [
                      Container(
                        width: 5.w,
                        height: 67.h,
                        color: context.theme.primaryColor,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.exampleLightBulb,
                              style: AppStyles.s14W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            5.verticalSpace,
                            Text(
                              context
                                  .tr
                                  .tenFullGallons100LEachOneHalfFullTotalLiters,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.cancel,
                    onTap: () {
                      NavigationService.I.pop();
                    },
                    padding: EdgeInsets.symmetric(vertical: 18.r),
                    textColor: context.customColor.text1,
                    borderRadius: 18.r,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: AppButton(
                    onClick: () async {
                      final result = await NavigationService.I.pushNamed(
                        AppRouteName.inventorySliderScreen,
                      );

                      NavigationService.I.pop(result);
                    },
                    text: context.tr.goToSlider,
                    enabled: true,
                    padding: EdgeInsets.symmetric(vertical: 18.r),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
