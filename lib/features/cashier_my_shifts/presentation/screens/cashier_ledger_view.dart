import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:flutter/material.dart';

class CashierLedgerView extends StatelessWidget {
  const CashierLedgerView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 56.r,
                color: context.customColor.text2,
              ),
              16.verticalSpace,
              Text(
                context.tr.accountStatement,
                style: AppStyles.s18W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              8.verticalSpace,
              Text(
                context.tr.manageRequestsAndViewHistory,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
                textAlign: TextAlign.center,
              ),
              24.verticalSpace,
              AppButton(
                enabled: true,
                text: context.tr.accountStatement,
                onClick: () {
                  NavigationService.I.pushNamed(
                    AppRouteName.accountStatementScreen,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
