import 'package:equatable/equatable.dart';

import '../../../../core/errors/api_failure.dart';

sealed class BranchOwnerApproveRejectState extends Equatable {
  const BranchOwnerApproveRejectState();

  @override
  List<Object> get props => [];
}

final class BranchOwnerApproveRejectInitial
    extends BranchOwnerApproveRejectState {
  const BranchOwnerApproveRejectInitial();
}

final class BranchOwnerApproveRejectLoading
    extends BranchOwnerApproveRejectState {
  const BranchOwnerApproveRejectLoading();
}

final class BranchOwnerApproveRejectExpenseSuccess
    extends BranchOwnerApproveRejectState {
  const BranchOwnerApproveRejectExpenseSuccess();
}

final class BranchOwnerApproveRejectCustodyRequestSuccess
    extends BranchOwnerApproveRejectState {
  const BranchOwnerApproveRejectCustodyRequestSuccess();
}

final class BranchOwnerApproveRejectSalesTransferSuccess
    extends BranchOwnerApproveRejectState {
  const BranchOwnerApproveRejectSalesTransferSuccess();
}

final class BranchOwnerApproveRejectEscalationSuccess
    extends BranchOwnerApproveRejectState {
  const BranchOwnerApproveRejectEscalationSuccess();
}

final class BranchOwnerApproveRejectFailure
    extends BranchOwnerApproveRejectState {
  final ApiFailure failure;

  const BranchOwnerApproveRejectFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
