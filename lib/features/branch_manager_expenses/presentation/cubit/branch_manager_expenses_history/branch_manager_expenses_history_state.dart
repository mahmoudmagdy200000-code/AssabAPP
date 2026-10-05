import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/all_expense_response_model.dart';

sealed class BranchManagerExpensesHistoryState extends Equatable {
  const BranchManagerExpensesHistoryState();

  @override
  List<Object> get props => [];
}

final class BranchManagerExpensesHistoryInit
    extends BranchManagerExpensesHistoryState {
  const BranchManagerExpensesHistoryInit();
}

final class BranchManagerExpensesHistoryLoading
    extends BranchManagerExpensesHistoryState {
  const BranchManagerExpensesHistoryLoading();
}

final class BranchManagerExpensesHistorySuccess
    extends BranchManagerExpensesHistoryState {
  final AllExpenseResponseModel expenses;

  const BranchManagerExpensesHistorySuccess(this.expenses);

  @override
  List<Object> get props => [expenses];
}

final class BranchManagerExpensesHistoryFailure
    extends BranchManagerExpensesHistoryState {
  final ApiFailure failure;

  const BranchManagerExpensesHistoryFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class BranchManagerExpensesHistoryRemoveDraftLoading
    extends BranchManagerExpensesHistoryState {
  const BranchManagerExpensesHistoryRemoveDraftLoading();
}

final class BranchManagerExpensesHistoryRemoveDraftSuccess
    extends BranchManagerExpensesHistoryState {
  const BranchManagerExpensesHistoryRemoveDraftSuccess();
}

final class BranchManagerExpensesHistoryFilterFailure
    extends BranchManagerExpensesHistoryState {
  final ApiFailure failure;

  const BranchManagerExpensesHistoryFilterFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
