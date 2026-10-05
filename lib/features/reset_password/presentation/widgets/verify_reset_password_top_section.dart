import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/enums/auth_type.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/reset_password/data/models/verify_otp_arguments.dart';
import 'package:assab/features/reset_password/presentation/widgets/reset_password_top_section.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_reg_exp.dart';

class VerifyResetPasswordTopSection extends StatelessWidget {
  final VerifyOtpArguments verifyOtpArguments;

  const VerifyResetPasswordTopSection({
    super.key,
    required this.verifyOtpArguments,
  });

  @override
  Widget build(BuildContext context) {
    return ResetPasswordTopSection(
      title: context.tr.verifyYourIdentity,
      textWidget: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 5.r,
            children: [
              Text(
                context.tr.verifyYourIdentityDescPart1,
                textAlign: TextAlign.center,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              if (verifyOtpArguments.type == AuthType.email) ...[
                Text(
                  AppRegExp.maskEmail(verifyOtpArguments.identifier),
                  textAlign: TextAlign.center,
                  style: AppStyles.s14W400.copyWith(
                    color: context.theme.primaryColor,
                  ),
                ),
              ],
              if (verifyOtpArguments.type == AuthType.phone) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppSvg(assetName: AppAssets.arFlag, width: 20.r),
                    5.horizontalSpace,
                    Text(
                      AppRegExp.maskSaudiPhone(verifyOtpArguments.identifier),
                      textAlign: TextAlign.center,
                      style: AppStyles.s14W400.copyWith(
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          Text(
            context.tr.verifyYourIdentityDescPart2,
            textAlign: TextAlign.center,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
        ],
      ),
    );
  }
}
