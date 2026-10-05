import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../styles/app_styles.dart';

class UnauthorizedDialog extends StatelessWidget {
  final VoidCallback onDismiss;

  const UnauthorizedDialog({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.customColor.reversedTextColor,
      title: Icon(
        Icons.error_outline,
        size: 35.r,
        color: context.customColor.error,
      ),
      content: Text(
        context.tr.unauthorized_error_desc,
        textAlign: TextAlign.center,
        style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onDismiss();
            NavigationService.I.offAllNamed(AppRouteName.start);
          },
          child: Text(
            S.current.ok,
            style: AppStyles.s16W500.copyWith(
              color: context.theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
