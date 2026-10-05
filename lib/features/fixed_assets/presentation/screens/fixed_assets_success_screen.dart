import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

class FixedAssetsSuccessScreen extends StatelessWidget {
  final String title;
  final String? message;
  final double? spaceBetweenTitleAndMessage;

  const FixedAssetsSuccessScreen({
    super.key,
    required this.title,
    this.message,
    this.spaceBetweenTitleAndMessage,
  });

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
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppStyles.s20W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  if (message != null) ...[
                    spaceBetweenTitleAndMessage?.verticalSpace ??
                        8.verticalSpace,
                    Text(
                      message!,
                      textAlign: TextAlign.center,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            12.verticalSpace,
            CustomTextButton(
              text: context.tr.backToDashboard,
              onTap: () => NavigationService.I.popToFirst(),
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
