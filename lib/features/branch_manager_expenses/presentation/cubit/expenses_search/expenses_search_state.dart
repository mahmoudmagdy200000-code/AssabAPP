import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../data/models/all_expense_response_model.dart';

sealed class ExpensesSearchState extends Equatable {
  const ExpensesSearchState();

  @override
  List<Object> get props => [];
}

final class ExpensesSearchInitial extends ExpensesSearchState {
  const ExpensesSearchInitial();
}

final class ExpensesSearchLoading extends ExpensesSearchState {
  const ExpensesSearchLoading();
}

final class ExpensesSearchSuccess extends ExpensesSearchState {
  final AllExpenseResponseModel expenses;

  const ExpensesSearchSuccess(this.expenses);

  @override
  List<Object> get props => [expenses];
}

final class ExpensesSearchFailure extends ExpensesSearchState {
  final ApiFailure failure;

  const ExpensesSearchFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
