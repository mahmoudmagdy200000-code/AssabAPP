import 'package:flutter/material.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';

import '../styles/app_styles.dart';

class AppLocalFailure extends StatelessWidget {
  final bool withBorder;
  final VoidCallback? onRetry;

  const AppLocalFailure({super.key, this.withBorder = false, this.onRetry});

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
            Icon(Icons.error, size: 40.r, color: context.customColor.text1),
            8.verticalSpace,
            Text(
              context.tr.somethingWentWrongPleaseTryAgain,
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
