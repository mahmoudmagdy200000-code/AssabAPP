import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/strategies/user_type_strategy.dart';
import '../../data/models/expense_status_model.dart';
import '../../data/models/expense_type_model.dart';
import '../../domain/strategies/expenses_strategy.dart';

class ExpenseSubmittedSuccess extends StatelessWidget {
  final ExpensesStrategy expensesStrategy;
  final String expenseId;
  final ExpenseTypeModel expenseTypeModel;

  const ExpenseSubmittedSuccess({
    super.key,
    required this.expensesStrategy,
    required this.expenseId,
    required this.expenseTypeModel,
  });

  void get _navigateToDetailsScreen {
    expensesStrategy.navigateToDetailsScreen(
      expenseId,
      expenseTypeModel,
      BranchManagerUserStrategy(),
      ExpenseStatusModel(value: 'pending', color: '', label: ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.tr.expenseSubmittedSuccessfully,
                      textAlign: TextAlign.center,
                      style: AppStyles.s24W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    12.verticalSpace,
                    Text(
                      context.tr.expenseSubmittedSuccessfullyDesc1,
                      textAlign: TextAlign.center,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    Text(
                      context.tr.expenseSubmittedSuccessfullyDesc2,
                      textAlign: TextAlign.center,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppButton(
              onClick: () {
                NavigationService.I.popToFirst();
              },
              text: context.tr.backToDashboard,
              enabled: true,
            ),
            16.verticalSpace,
            AppButton(
              onClick: () => _navigateToDetailsScreen,
              text: context.tr.seeDetails,
              isTransparent: true,
              enabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
