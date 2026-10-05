import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/branch_order_modification_response.dart';

sealed class BranchGetModificationState extends Equatable {
  const BranchGetModificationState();

  @override
  List<Object> get props => [];
}

final class BranchGetModificationInit extends BranchGetModificationState {
  const BranchGetModificationInit();
}

final class BranchGetModificationLoading extends BranchGetModificationState {
  const BranchGetModificationLoading();
}

final class BranchGetModificationSuccess extends BranchGetModificationState {
  final BranchOrderModificationResponse data;

  const BranchGetModificationSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class BranchGetModificationFailure extends BranchGetModificationState {
  final ApiFailure failure;

  const BranchGetModificationFailure(this.failure);
}
