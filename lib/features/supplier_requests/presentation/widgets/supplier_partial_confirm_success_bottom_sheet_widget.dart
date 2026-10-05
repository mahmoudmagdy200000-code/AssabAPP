import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

class SupplierPartialConfirmSuccessBottomSheetWidget extends StatelessWidget {
  const SupplierPartialConfirmSuccessBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr.modificationSubmitted,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    context
                        .tr
                        .youHaveModificationRequestHasBeenSubmittedRiyadhBranchMalqa,
                    textAlign: TextAlign.center,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            CustomTextButton(
              text: context.tr.backToDashboard,
              onTap: () => NavigationService.I.popToFirst(),
              backgroundColor: context.theme.primaryColor,
              textColor: context.customColor.reversedTextColor,
              borderRadius: 1000.r,
              padding: EdgeInsets.symmetric(vertical: 14.r),
            ),
            // 12.verticalSpace,
            // CustomTextButton(
            //   text: context.tr.seeOrderDetailsModification,
            //   onTap: () => NavigationService.I.pop(),
            //   backgroundColor: Colors.transparent,
            //   textColor: context.customColor.text1,
            //   borderRadius: 1000.r,
            //   padding: EdgeInsets.symmetric(vertical: 14.r),
            // ),
          ],
        ),
      ),
    );
  }
}
