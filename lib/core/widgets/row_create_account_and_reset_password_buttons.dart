import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:flutter/material.dart';

import 'app_button.dart';
import 'create_account_bottom_sheet_widget.dart';

class RowCreateAccountAndResetPasswordButtons extends StatelessWidget {
  const RowCreateAccountAndResetPasswordButtons({super.key});

  void _showCreateAccountBottomSheet({required BuildContext context}) {
    AppBottomSheet.show(
      context,
      (context) => const CreateAccountBottomSheetWidget(),
    );
  }

  void _goToResetPasswordScreen() {
    NavigationService.I.pushNamed(AppRouteName.resetPasswordWithEmailScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            onClick: () => _showCreateAccountBottomSheet(context: context),
            isTransparent: true,
            enabled: true,
            text: context.tr.createNewAccount,
            textColor: context.customColor.text1,
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: AppButton(
            onClick: _goToResetPasswordScreen,
            isTransparent: true,
            enabled: true,
            text: context.tr.resetPassword,
            textColor: context.customColor.text1,
          ),
        ),
      ],
    );
  }
}
