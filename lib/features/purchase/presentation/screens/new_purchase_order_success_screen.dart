import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_text_button.dart';

class NewPurchaseOrderSuccessScreen extends StatelessWidget {
  const NewPurchaseOrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 50.r,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    context.tr.multiOrderSubmitted,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ],
              ),
            ),
            30.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: ButtonTextIcon(
                    onTap: () {},
                    label: context.tr.newOrder,
                    icon: AppSvg(
                      assetName: AppAssets.cart,
                      colorFilter: ColorFilter.mode(
                        context.customColor.reversedTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    backgroundColor: context.theme.primaryColor,
                    textColor: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(1000.r),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: CustomTextButton(
                    onTap: () {},
                    text: context.tr.newOrder,
                    textColor: context.theme.primaryColor,
                    borderColor: context.theme.primaryColor,
                    borderRadius: 1000.r,
                    padding: EdgeInsets.symmetric(
                      vertical: 18.r,
                      horizontal: 19.r,
                    ),
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            CustomTextButton(
              onTap: () {
                NavigationService.I.offAllNamed(AppRouteName.start);
              },
              text: context.tr.backToDashboard,
              textColor: context.customColor.text4,
              borderRadius: 1000.r,
              padding: EdgeInsets.symmetric(vertical: 18.r, horizontal: 19.r),
            ),
          ],
        ),
      ),
    );
  }
}
