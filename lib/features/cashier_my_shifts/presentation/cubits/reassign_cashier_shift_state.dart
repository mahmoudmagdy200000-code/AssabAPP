part of 'reassign_cashier_shift_cubit.dart';

@immutable
sealed class ReassignedShiftActionsState {}

final class ReassignShiftActionInitial extends ReassignedShiftActionsState {}

final class ReassignShiftActionLoading extends ReassignedShiftActionsState {}

final class ReassignShiftActionFailure extends ReassignedShiftActionsState {
  final ApiFailure failure;

  ReassignShiftActionFailure(this.failure);
}

final class ReassignShiftActionSuccess extends ReassignedShiftActionsState {}
