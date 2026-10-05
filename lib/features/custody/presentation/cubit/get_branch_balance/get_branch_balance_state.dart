import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/custody_branch_balance_response.dart';

sealed class GetBranchBalanceState extends Equatable {
  const GetBranchBalanceState();

  @override
  List<Object> get props => [];
}

final class GetBranchBalanceInit extends GetBranchBalanceState {
  const GetBranchBalanceInit();
}

final class GetBranchBalanceLoading extends GetBranchBalanceState {
  const GetBranchBalanceLoading();
}

final class GetBranchBalanceSuccess extends GetBranchBalanceState {
  final CustodyBranchBalanceResponse balance;

  const GetBranchBalanceSuccess(this.balance);

  @override
  List<Object> get props => [balance];
}

final class GetBranchBalanceFailure extends GetBranchBalanceState {
  final ApiFailure failure;

  const GetBranchBalanceFailure(this.failure);
  @override
  List<Object> get props => [failure];
}
