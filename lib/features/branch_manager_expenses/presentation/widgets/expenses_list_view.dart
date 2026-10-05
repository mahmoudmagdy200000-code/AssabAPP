import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expense_data_model.dart';
import 'package:assab/features/branch_manager_expenses/presentation/screens/expense_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strategies/user_type_strategy.dart';
import '../../domain/strategies/expense_category.dart';
import '../cubit/branch_manager_expenses_history/branch_manager_expenses_history_cubit.dart';
import '../cubit/expense_details/expense_details_cubit.dart';
import '../screens/draft_expense_details_screen.dart';
import 'expenses_widget.dart';

class ExpensesListView extends StatelessWidget {
  final List<ExpenseDataModel> expenses;
  final ScrollController? controller;
  final VoidCallback? onClickDraftExpense;
  final bool isExpanded;
  final UserTypeStrategy userTypeStrategy;
  final bool loadAllExpenses;
  final int selectedTab;

  const ExpensesListView({
    super.key,
    required this.expenses,
    this.controller,
    this.onClickDraftExpense,
    this.isExpanded = true,
    required this.userTypeStrategy,
    this.loadAllExpenses = false,
    this.selectedTab = 0,
  });

  void _onClickDraftExpense(
    BuildContext context,
    ExpenseDataModel expense,
  ) async {
    final branchManagerExpensesHistoryCubit = context
        .read<BranchManagerExpensesHistoryCubit>();

    await NavigationService.I.push(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<ExpenseDetailsCubit>()),
            BlocProvider.value(value: branchManagerExpensesHistoryCubit),
          ],
          child: DraftExpenseDetailsScreen(expenseDataModel: expense),
        ),
      ),
    );

    if (context.mounted) {
      if (selectedTab == 0) {
        context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(
          type: const AllExpense(),
        );
      } else if (selectedTab == 1) {
        context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(
          type: const DraftExpense(),
        );
      } else {
        context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(
          type: ExpenseCategory.fromType(expense.expenseType.value),
        );
      }
    }
  }

  void _onClickExpense(BuildContext context, ExpenseDataModel expense) async {
    await NavigationService.I.push(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
            BlocProvider(create: (context) => getIt<ExpenseDetailsCubit>()),
          ],
          child: ExpenseDetailsScreen(
            id: expense.id,
            expenseTypeModel: expense.expenseType,
            userTypeStrategy: userTypeStrategy,
            expenseStatusModel: expense.status,
          ),
        ),
      ),
    );

    if (context.mounted) {
      if (loadAllExpenses) {
        context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(
          type: const AllExpense(),
        );
      } else if (selectedTab == 1) {
        context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(
          type: const DraftExpense(),
        );
      } else {
        context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(
          type: ExpenseCategory.fromType(expense.expenseType.value),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isExpanded) {
      return Expanded(child: _buildContent(context));
    } else {
      return _buildContent(context);
    }
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      padding: EdgeInsets.only(top: 12.r, left: 12.r, right: 12.r),
      child: ListView.builder(
        controller: controller,
        itemCount: expenses.length,
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final expense = expenses[index];

          return AppGestureDetectorButton(
            onTap: () => _onClickExpense(context, expense),
            child: Column(
              children: [
                ExpensesWidget(
                  amount: expense.amount,
                  createdAt: expense.createdAt,
                  date: expense.date,
                  expenseName: expense.expenseName,
                  expenseType: expense.expenseType,
                  status: expense.status,
                  onClickDraft:
                      onClickDraftExpense ??
                      () => _onClickDraftExpense(context, expense),
                ),
                10.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }
}
