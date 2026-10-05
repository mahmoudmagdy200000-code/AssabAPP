part of 'handover_cubit.dart';

@immutable
sealed class HandoverState {}

final class HandoverInitial extends HandoverState {}

final class HandoverCashiersFetchingLoading extends HandoverState {}

final class HandoverCashiersFetchingEmpty extends HandoverState {}

final class HandoverCashiersFetchingSuccess extends HandoverState {
  final List<HandoverUserItem> usersList;
  HandoverCashiersFetchingSuccess({required this.usersList});
}

final class HandoverCashiersFetchingFailure extends HandoverState {
  final ApiFailure failure;
  HandoverCashiersFetchingFailure({required this.failure});
}

final class RecordingHandoverLoading extends HandoverState {}

final class RecordingHandoverSuccess extends HandoverState {}

final class RecordingHandoverFailure extends HandoverState {
  final ApiFailure failure;
  RecordingHandoverFailure({required this.failure});
}
