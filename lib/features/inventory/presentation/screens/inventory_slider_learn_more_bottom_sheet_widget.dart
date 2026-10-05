import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/custom_divider.dart';

class InventorySliderLearnMoreBottomSheetWidget extends StatelessWidget {
  const InventorySliderLearnMoreBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
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
                        context.tr.tenFullGallons100LEachOneHalfFullTotalLiters,
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
    );
  }
}
