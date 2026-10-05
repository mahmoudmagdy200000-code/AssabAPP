import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../data/models/branch_custody_transactions_response.dart';

sealed class GetBranchBalanceTransactionsState extends Equatable {
  const GetBranchBalanceTransactionsState();

  @override
  List<Object> get props => [];
}

final class GetBranchBalanceTransactionsInit
    extends GetBranchBalanceTransactionsState {
  const GetBranchBalanceTransactionsInit();
}

final class GetBranchBalanceTransactionsLoading
    extends GetBranchBalanceTransactionsState {
  const GetBranchBalanceTransactionsLoading();
}

final class GetBranchBalanceTransactionsSuccess
    extends GetBranchBalanceTransactionsState {
  final BranchCustodyTransactionsResponse response;

  const GetBranchBalanceTransactionsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetBranchBalanceTransactionsFailure
    extends GetBranchBalanceTransactionsState {
  final ApiFailure failure;

  const GetBranchBalanceTransactionsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
