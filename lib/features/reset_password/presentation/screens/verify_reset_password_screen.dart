import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/features/reset_password/data/models/verify_otp_arguments.dart';
import 'package:flutter/material.dart';

import '../widgets/verify_reset_password_bottom_section.dart';
import '../widgets/verify_reset_password_top_section.dart';

class VerifyResetPasswordScreen extends StatelessWidget {
  const VerifyResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final verifyOtpArguments = context.arguments as VerifyOtpArguments;

    return AppScaffold(
      child: AppPaddingWidget(
        child: SingleChildScrollView(
          child: Column(
            children: [
              VerifyResetPasswordTopSection(
                verifyOtpArguments: verifyOtpArguments,
              ),
              32.verticalSpace,
              VerifyResetPasswordBottomSection(
                verifyOtpArguments: verifyOtpArguments,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
