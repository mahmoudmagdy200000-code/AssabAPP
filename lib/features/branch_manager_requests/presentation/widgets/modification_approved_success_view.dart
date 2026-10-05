import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

class ModificationApprovedSuccessView extends StatelessWidget {
  const ModificationApprovedSuccessView({super.key});

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
                    context.tr.modificationApproved,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    context.tr.theItemHasBeenUpdatedWithTheApprovedDetails,
                    textAlign: TextAlign.center,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  20.verticalSpace,
                  Text(
                    context
                        .tr
                        .youCanViewTheOriginalRequestAndTheNewModification,
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
              text: context.tr.cancel,
              onTap: () {
                NavigationService.I.popToFirst();
              },
              borderRadius: 1000.r,
              padding: EdgeInsets.symmetric(vertical: 18.r),
              textColor: context.customColor.text1,
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
