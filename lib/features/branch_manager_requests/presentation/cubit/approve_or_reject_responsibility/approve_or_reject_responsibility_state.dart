part of 'approve_or_reject_responsibility_cubit.dart';

@immutable
sealed class ApproveOrRejectResponsibilityState {}

final class ApproveOrRejectResponsibilityInitial
    extends ApproveOrRejectResponsibilityState {}

final class ApproveOrRejectResponsibilityLoading
    extends ApproveOrRejectResponsibilityState {}

final class ApproveOrRejectResponsibilitySuccess
    extends ApproveOrRejectResponsibilityState {}

final class ApproveOrRejectResponsibilityFailed
    extends ApproveOrRejectResponsibilityState {
  final ApiFailure failure;

  ApproveOrRejectResponsibilityFailed(this.failure);
}
