import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/services/navigation/navigation_service.dart';

class FixedAssetsSearchResultFooterWidget extends StatelessWidget {
  const FixedAssetsSearchResultFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: context.customColor.text4.withValues(alpha: 0.05),
            blurRadius: 20.r,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: AppButton(
          onClick: () {
            NavigationService.I.pop();
          },
          text: context.tr.backToDashboard,
          borderColor: context.customColor.text2,
          textColor: context.customColor.text1,
        ),
      ),
    );
  }
}
