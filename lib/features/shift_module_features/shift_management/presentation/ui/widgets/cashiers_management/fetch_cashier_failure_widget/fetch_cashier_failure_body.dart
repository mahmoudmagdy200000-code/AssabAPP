import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:flutter/material.dart';

class ShiftManagementFailureBody extends StatelessWidget {
  const ShiftManagementFailureBody({super.key, required this.failure});

  final ApiFailure failure;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        130.verticalSpace,

        // failure.error.message?.compareTo('Unauthenticated') == 1 ?
        //   AppAssetImage(image: AppAssets.unauthorized ,
        //   height: 140.h,
        //   width: 120.w,
        // ) :
        Icon(failure.icon, size: 80.h, color: context.customColor.text3),

        20.verticalSpace,

        Text(
          context.tr.server_error,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: context.customColor.error,
          ),
        ),

        15.verticalSpace,

        SizedBox(
          width: 260.w,
          child: Text(
            context.tr.server_error_desc,
            style: context.theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),

        45.verticalSpace,
        AppButton(
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          borderRadius: BorderRadius.circular(12.r),
          onClick: () {
            Navigator.pushReplacementNamed(context, AppRouteName.onboarding);
          },
          enabled: true,
          text: context.tr.login,
        ),
      ],
    );
  }
}
