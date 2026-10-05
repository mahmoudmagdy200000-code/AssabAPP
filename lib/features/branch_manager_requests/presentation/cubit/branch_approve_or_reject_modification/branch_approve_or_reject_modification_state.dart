import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class BranchApproveOrRejectModificationState extends Equatable {
  const BranchApproveOrRejectModificationState();

  @override
  List<Object> get props => [];
}

final class BranchApproveOrRejectModificationInit
    extends BranchApproveOrRejectModificationState {
  const BranchApproveOrRejectModificationInit();
}

final class BranchApproveOrRejectModificationLoading
    extends BranchApproveOrRejectModificationState {
  const BranchApproveOrRejectModificationLoading();
}

final class BranchApproveOrRejectModificationSuccess
    extends BranchApproveOrRejectModificationState {
  const BranchApproveOrRejectModificationSuccess();
}

final class BranchApproveOrRejectModificationFailure
    extends BranchApproveOrRejectModificationState {
  final ApiFailure failure;

  const BranchApproveOrRejectModificationFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
