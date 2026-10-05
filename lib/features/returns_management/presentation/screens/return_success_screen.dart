import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_text_button.dart';

class ReturnSuccessScreen extends StatelessWidget {
  final String supplierName;

  const ReturnSuccessScreen({super.key, required this.supplierName});

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
                    context.tr.returnRequestSubmitted,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    context.tr
                        .pendingApprovalFromSupplierYouWillBeNotifiedWhenTheyRespond(
                          supplierName,
                        ),
                    textAlign: TextAlign.center,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ],
              ),
            ),
            30.verticalSpace,
            CustomTextButton(
              onTap: () {
                NavigationService.I.pop();
              },
              text: context.tr.backToDashboard,
              textColor: context.customColor.reversedTextColor,
              borderColor: Colors.transparent,
              backgroundColor: context.theme.primaryColor,
              borderRadius: 1000.r,
              padding: EdgeInsets.symmetric(vertical: 18.r, horizontal: 19.r),
            ),
          ],
        ),
      ),
    );
  }
}
