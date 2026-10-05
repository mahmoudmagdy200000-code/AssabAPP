import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../assab_app.dart';
import '../styles/app_styles.dart';

class AppErrorProductionScreen extends StatelessWidget {
  final String? message;

  const AppErrorProductionScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: context.customColor.error,
                size: 50.r,
              ),
              20.verticalSpace,
              Text(
                context.tr.somethingWentWrong,
                style: AppStyles.s20W500.copyWith(
                  color: context.customColor.text1,
                ),
                textAlign: TextAlign.center,
              ),
              10.verticalSpace,
              Text(
                message ?? context.tr.somethingWentWrong,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
                textAlign: TextAlign.center,
              ),
              30.verticalSpace,
              ElevatedButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    runApp(const AssabApp());
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.customColor.error,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.r,
                    vertical: 12.r,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  context.tr.restartApp,
                  style: AppStyles.s15W400.copyWith(
                    color: context.customColor.reversedTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
