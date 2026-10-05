import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/cashier_branch_info_response.dart';

sealed class GetBranchInfoState extends Equatable {
  const GetBranchInfoState();

  @override
  List<Object> get props => [];
}

final class GetBranchInfoInit extends GetBranchInfoState {
  const GetBranchInfoInit();
}

final class GetBranchInfoLoading extends GetBranchInfoState {
  const GetBranchInfoLoading();
}

final class GetBranchInfoSuccess extends GetBranchInfoState {
  final CashierBranchInfoResponse branchInfo;

  const GetBranchInfoSuccess(this.branchInfo);

  @override
  List<Object> get props => [branchInfo];
}

final class GetBranchInfoFailure extends GetBranchInfoState {
  final ApiFailure failure;

  const GetBranchInfoFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
