import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

class InventorySuccessScreen extends StatelessWidget {
  final String title;
  final String desc;
  final VoidCallback? onBackToInventory;

  const InventorySuccessScreen({
    super.key,
    required this.title,
    required this.desc,
    this.onBackToInventory,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  12.verticalSpace,
                  Text(
                    desc,
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
              text: context.tr.backToInventory,
              onTap: () {
                if (onBackToInventory != null) {
                  onBackToInventory!();
                } else {
                  NavigationService.I.pop();
                }
              },
              backgroundColor: context.theme.primaryColor,
              textColor: context.customColor.reversedTextColor,
              borderRadius: 1000.r,
              padding: EdgeInsets.symmetric(vertical: 18.r),
            ),
          ],
        ),
      ),
    );
  }
}
