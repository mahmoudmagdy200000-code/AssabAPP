import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';

class SeeExpensesHistoryButton extends StatelessWidget {
  const SeeExpensesHistoryButton({super.key});

  void _goToBranchManagerExpensesHistory() {
    NavigationService.I.pushNamed(
      AppRouteName.branchManagerExpensesHistoryScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: _goToBranchManagerExpensesHistory,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(1000.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(vertical: 18.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.tr.seeExpenseHistory,
              style: AppStyles.s12W500.copyWith(
                color: context.theme.primaryColor,
              ),
            ),
            10.horizontalSpace,
            AppSvg(
              assetName: AppAssets.arrowRight,
              width: 20.w,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
