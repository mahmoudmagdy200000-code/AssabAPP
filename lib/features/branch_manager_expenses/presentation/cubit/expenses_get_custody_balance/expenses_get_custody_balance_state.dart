import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ExpensesGetCustodyBalanceState extends Equatable {
  const ExpensesGetCustodyBalanceState();

  @override
  List<Object> get props => [];
}

final class ExpensesGetCustodyBalanceInit
    extends ExpensesGetCustodyBalanceState {
  const ExpensesGetCustodyBalanceInit();
}

final class ExpensesGetCustodyBalanceLoading
    extends ExpensesGetCustodyBalanceState {
  const ExpensesGetCustodyBalanceLoading();
}

final class ExpensesGetCustodyBalanceSuccess
    extends ExpensesGetCustodyBalanceState {
  final double balance;

  const ExpensesGetCustodyBalanceSuccess(this.balance);

  @override
  List<Object> get props => [balance];
}

final class ExpensesGetCustodyBalanceFailure
    extends ExpensesGetCustodyBalanceState {
  final ApiFailure failure;

  const ExpensesGetCustodyBalanceFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
