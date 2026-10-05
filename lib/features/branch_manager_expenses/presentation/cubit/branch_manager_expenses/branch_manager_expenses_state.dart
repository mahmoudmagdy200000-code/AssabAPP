part of 'branch_manager_expenses_cubit.dart';

sealed class BranchManagerExpensesState extends Equatable {
  const BranchManagerExpensesState();

  @override
  List<Object> get props => [];
}

final class BranchManagerExpensesInitial extends BranchManagerExpensesState {
  const BranchManagerExpensesInitial();
}

final class BranchManagerExpensesSummaryLoading
    extends BranchManagerExpensesState {
  const BranchManagerExpensesSummaryLoading();
}

final class BranchManagerRecentExpensesLoading
    extends BranchManagerExpensesState {
  const BranchManagerRecentExpensesLoading();
}

final class BranchManagerGetExpensesSummarySuccess
    extends BranchManagerExpensesState {
  final ExpensesSummaryEntity expensesSummary;

  const BranchManagerGetExpensesSummarySuccess(this.expensesSummary);

  @override
  List<Object> get props => [expensesSummary];
}

final class BranchManagerGetRecentExpensesSuccess
    extends BranchManagerExpensesState {
  final List<ExpensesEntity> recentExpenses;

  const BranchManagerGetRecentExpensesSuccess(this.recentExpenses);

  @override
  List<Object> get props => [recentExpenses];
}

final class BranchManagerExpensesSummaryFailure
    extends BranchManagerExpensesState {
  final ApiFailure failure;

  const BranchManagerExpensesSummaryFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class BranchManagerRecentExpensesFailure
    extends BranchManagerExpensesState {
  final ApiFailure failure;

  const BranchManagerRecentExpensesFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
