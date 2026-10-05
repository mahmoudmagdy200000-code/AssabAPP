import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';

sealed class BranchManagerResetMyPasswordState extends Equatable {
  const BranchManagerResetMyPasswordState();

  @override
  List<Object> get props => [];
}

final class BranchManagerResetMyPasswordInitial
    extends BranchManagerResetMyPasswordState {
  const BranchManagerResetMyPasswordInitial();
}

final class BranchManagerResetMyPasswordLoading
    extends BranchManagerResetMyPasswordState {
  const BranchManagerResetMyPasswordLoading();
}

final class BranchManagerResetMyPasswordSuccess
    extends BranchManagerResetMyPasswordState {
  const BranchManagerResetMyPasswordSuccess();
}

final class BranchManagerResetMyPasswordFailure
    extends BranchManagerResetMyPasswordState {
  final ApiFailure failure;

  const BranchManagerResetMyPasswordFailure(this.failure);

  @override
  List<Object> get props => [failure];
}