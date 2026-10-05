import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

class CreatePurchaseOrderSuccessScreen extends StatelessWidget {
  const CreatePurchaseOrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    context.tr.orderSubmitted,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    context.tr.orderSubmittedDesc,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    context.tr.orderSubmittedDesc2,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            CustomTextButton(
              text: context.tr.backToDashboard,
              onTap: () {
                NavigationService.I.pop();
              },
              borderRadius: 1000.r,
              textColor: context.customColor.reversedTextColor,
              backgroundColor: context.theme.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 24.r),
              borderColor: Colors.transparent,
            ),
            16.verticalSpace,
            CustomTextButton(
              text: context.tr.seeDetails,
              onTap: () {
                NavigationService.I.pop();
              },
              borderRadius: 1000.r,
              textColor: context.customColor.text1,
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 24.r),
            ),
          ],
        ),
      ),
    );
  }
}
