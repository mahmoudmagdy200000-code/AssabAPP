part of 'approve_and_reject_handover_cubit.dart';

@immutable
sealed class ApproveAndRejectHandoverState {}

final class ApproveAndRejectHandoverInitial
    extends ApproveAndRejectHandoverState {}

final class HandoverActionSuccess extends ApproveAndRejectHandoverState {}

final class HandoverActionLoading extends ApproveAndRejectHandoverState {}

final class HandoverActionFailure extends ApproveAndRejectHandoverState {
  final ApiFailure failure;

  HandoverActionFailure(this.failure);
}
