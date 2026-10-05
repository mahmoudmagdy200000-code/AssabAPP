import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

import '../widgets/reset_password_active_account_form.dart';
import '../widgets/reset_password_active_account_top_section.dart';

class ResetPasswordActiveAccountScreen extends StatelessWidget {
  const ResetPasswordActiveAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: context.theme.primaryColor,
      child: Column(
        children: [
          const ResetPasswordActiveAccountTopSection(),
          34.verticalSpace,
          const ResetPasswordActiveAccountForm(),
        ],
      ),
    );
  }
}
