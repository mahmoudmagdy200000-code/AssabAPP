import 'package:flutter/material.dart';

import '../../core/errors/api_failure.dart';
import '../../core/extensions/build_context_extensions.dart';
import '../../core/extensions/number_extensions.dart';
import '../services/navigation/navigation_service.dart';
import '../styles/app_styles.dart';

class AppDialog {
  AppDialog._();

  static void showErrorDialog({
    required BuildContext context,
    required ApiFailure failure,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.customColor.reversedTextColor,
          title: Icon(
            failure.icon,
            size: 35.r,
            color: context.customColor.error,
          ),
          content: Text(
            failure.error.getErrorMessage,
            textAlign: TextAlign.center,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
          ),
          actions: [
            TextButton(
              onPressed: () => NavigationService.I.pop(),
              child: Text(
                'Ok',
                style: AppStyles.s16W500.copyWith(
                  color: context.theme.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showCustomDialog({
    required BuildContext context,
    required WidgetBuilder builder,
    bool? barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible!,
      builder: builder,
    );
  }
}
