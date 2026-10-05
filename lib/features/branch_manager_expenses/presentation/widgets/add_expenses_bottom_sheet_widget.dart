import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_divider.dart';
import '../../domain/strategies/expenses_strategy.dart';
import 'expenses_type_widget.dart';

class AddExpensesBottomSheetWidget extends StatelessWidget {
  const AddExpensesBottomSheetWidget({super.key});

  void _pop() {
    NavigationService.I.pop();
  }

  void _gotToQuickCashExpenseScreen(BuildContext context) {
    _pop();
    NavigationService.I.pushNamed(AppRouteName.quickCashExpenseScreen);
  }

  void _gotToSingleExpenseScreen(BuildContext context) {
    _pop();
    NavigationService.I.pushNamed(AppRouteName.singleExpenseScreen);
  }

  void _gotToPreApprovalRequestScreen(BuildContext context) {
    _pop();
    NavigationService.I.pushNamed(AppRouteName.preApprovalRequestScreen);
  }

  void _gotToGroupedInvoicesScreen(BuildContext context) {
    _pop();
    NavigationService.I.pushNamed(AppRouteName.groupedInvoicesScreen);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppPaddingWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(context.tr.addExpense, style: AppStyles.s20W500),
              5.verticalSpace,
              Text(
                context.tr.whatKindOfExpenseAreYouAdding,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              14.verticalSpace,
              const CustomDivider(),
              14.verticalSpace,
              Text(
                context.tr.cashExpense,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              12.verticalSpace,
              ExpensesTypeWidget(
                expensesStrategy: QuickCashExpensesStrategy(),
                onClick: () => _gotToQuickCashExpenseScreen(context),
              ),
              12.verticalSpace,
              ExpensesTypeWidget(
                expensesStrategy: PreApprovalExpensesStrategy(),
                onClick: () => _gotToPreApprovalRequestScreen(context),
              ),
              12.verticalSpace,
              Text(
                context.tr.invoiceExpense,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              12.verticalSpace,
              ExpensesTypeWidget(
                expensesStrategy: SingleInvoiceExpensesStrategy(),
                onClick: () => _gotToSingleExpenseScreen(context),
              ),
              12.verticalSpace,
              ExpensesTypeWidget(
                expensesStrategy: GroupedInvoiceExpensesStrategy(),
                onClick: () => _gotToGroupedInvoicesScreen(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
