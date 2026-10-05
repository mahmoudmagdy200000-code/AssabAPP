import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

class AppFailureWidget extends StatelessWidget {
  final ApiFailure failure;
  final bool withBorder;
  final VoidCallback? onRetry;

  const AppFailureWidget({
    super.key,
    required this.failure,
    this.onRetry,
    this.withBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.r),
        border: withBorder
            ? Border.all(color: context.customColor.border)
            : null,
      ),
      padding: EdgeInsets.all(16.r),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(failure.icon, size: 40.r, color: context.customColor.text1),
            8.verticalSpace,
            Text(
              failure.error.getErrorMessage,
              textAlign: TextAlign.center,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text1,
              ),
            ),
            8.verticalSpace,
            IconButton(
              onPressed: onRetry,
              icon: Icon(
                Icons.refresh,
                size: 24.r,
                color: context.customColor.text1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
