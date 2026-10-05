import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../../../shared/models/cancel_reason/cancel_reason_response.dart';

sealed class BranchGetCancelReasonState extends Equatable {
  const BranchGetCancelReasonState();

  @override
  List<Object> get props => [];
}

final class BranchGetCancelReasonInit extends BranchGetCancelReasonState {
  const BranchGetCancelReasonInit();
}

final class BranchGetCancelReasonLoading extends BranchGetCancelReasonState {
  const BranchGetCancelReasonLoading();
}

final class BranchGetCancelReasonSuccess extends BranchGetCancelReasonState {
  final CancelReasonResponse data;

  const BranchGetCancelReasonSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class BranchGetCancelReasonFailure extends BranchGetCancelReasonState {
  final ApiFailure failure;

  const BranchGetCancelReasonFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
