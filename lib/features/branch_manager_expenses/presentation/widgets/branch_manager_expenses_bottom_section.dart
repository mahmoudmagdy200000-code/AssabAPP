import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expense_status_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expense_type_model.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/expenses_entity.dart';
import 'package:flutter/material.dart';

import 'expenses_widget.dart';

class BranchManagerExpensesBottomSection extends StatelessWidget {
  final List<ExpensesEntity> recentExpenses;

  const BranchManagerExpensesBottomSection({
    super.key,
    required this.recentExpenses,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.customColor.text2,
          borderRadius: BorderRadius.circular(30.r),
        ),
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Text(
              context.tr.top10RecentExpenses,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            10.verticalSpace,
            ListView.builder(
              itemCount: recentExpenses.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final expense = recentExpenses[index];

                return Column(
                  children: [
                    ExpensesWidget(
                      amount: expense.amount,
                      createdAt: expense.createdAt,
                      date: expense.date,
                      expenseName: expense.expenseName,
                      expenseType: ExpenseTypeModel(
                        value: expense.expenseType.expenseType,
                        label: expense.expenseType.displayName(context),
                      ),
                      status: ExpenseStatusModel(
                        value: expense.status,
                        label: '',
                        color: '',
                      ),
                    ),
                    if (index != recentExpenses.length - 1) 10.verticalSpace,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
