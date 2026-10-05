import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ApproveOrRejectOrderState extends Equatable {
  const ApproveOrRejectOrderState();

  @override
  List<Object> get props => [];
}

final class ApproveOrRejectOrderInit extends ApproveOrRejectOrderState {
  const ApproveOrRejectOrderInit();
}

final class ApproveOrRejectOrderLoading extends ApproveOrRejectOrderState {
  const ApproveOrRejectOrderLoading();
}

final class ApproveOrRejectOrderSuccess extends ApproveOrRejectOrderState {
  const ApproveOrRejectOrderSuccess();
}

final class ApproveOrRejectOrderFailure extends ApproveOrRejectOrderState {
  final ApiFailure failure;

  const ApproveOrRejectOrderFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
