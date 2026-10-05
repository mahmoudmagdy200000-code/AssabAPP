import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class RejectApproveDelayState extends Equatable {
  const RejectApproveDelayState();

  @override
  List<Object> get props => [];
}

final class RejectApproveDelayInit extends RejectApproveDelayState {
  const RejectApproveDelayInit();
}

final class RejectApproveDelayLoading extends RejectApproveDelayState {
  const RejectApproveDelayLoading();
}

final class RejectApproveDelaySuccess extends RejectApproveDelayState {
  const RejectApproveDelaySuccess();
}

final class RejectApproveRejectedDelaySuccess extends RejectApproveDelayState {
  const RejectApproveRejectedDelaySuccess();
}

final class RejectApproveDelayFailure extends RejectApproveDelayState {
  final ApiFailure failure;

  const RejectApproveDelayFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
