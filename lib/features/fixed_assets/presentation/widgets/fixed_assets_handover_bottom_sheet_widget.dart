import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

import '../../domain/enums/fixed_assets_handover_status_filter_enum.dart';

class FixedAssetsHandoverBottomSheetWidget extends StatelessWidget {
  const FixedAssetsHandoverBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.startingAHandover,
                    style: AppStyles.s20W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    context.tr.youreAboutToInitiateAFormalAssetHandover,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  15.verticalSpace,
                  AppAssetImage(
                    image: AppAssets.handoverBg,
                    height: 150.h,
                    borderRadius: BorderRadius.zero,
                  ),
                  20.verticalSpace,
                  Text(
                    context.tr.pleaseEnsure,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: context.customColor.text3,
                        size: 6.r,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          context.tr.allItemsCounted,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: context.customColor.text3,
                        size: 6.r,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          context.tr.photosOrNotesAdded,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: context.customColor.text3,
                        size: 6.r,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          context.tr.everythingInYourCustodyAccountedFor,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  15.verticalSpace,
                  const CustomDivider(),
                  15.verticalSpace,
                  Text(
                    context.tr.onceCompletedYouLoseEditAccess,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  15.verticalSpace,
                  const CustomDivider(),
                  15.verticalSpace,
                  Text(
                    context.tr.proceedWithHandover,
                    style: AppStyles.s15W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            CustomTextButton(
              text: context.tr.startHandover,
              onTap: () {
                NavigationService.I.pop();

                NavigationService.I.pushNamed(
                  AppRouteName.fixedAssetsHandoverScreen,
                  arguments: FixedAssetsHandoverStatusFilterEnum.global.value,
                );
              },
              backgroundColor: context.theme.primaryColor,
              textColor: context.customColor.reversedTextColor,
              padding: EdgeInsets.symmetric(vertical: 16.r),
              borderRadius: 15.r,
              borderColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
