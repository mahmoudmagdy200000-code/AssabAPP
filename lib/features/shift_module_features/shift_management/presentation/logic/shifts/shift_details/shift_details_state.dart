part of 'shift_details_cubit.dart';

@immutable
abstract class ShiftDetailsState {}

class ShiftDetailsInitial extends ShiftDetailsState {}

class ShiftDetailsLoading extends ShiftDetailsState {}

class HandoverDetailsFailure extends ShiftDetailsState {
  final ApiFailure failure;

  HandoverDetailsFailure(this.failure);
}

class HandoverDetailsLoading extends ShiftDetailsState {}

class HandoverDetailsLoaded extends ShiftDetailsState {
  final HandoverStatusDetailsEntity handoverStatusDetails;
  HandoverDetailsLoaded(this.handoverStatusDetails);
}

class ShiftDetailsLoaded extends ShiftDetailsState {
  final ShiftEntity shift;

  ShiftDetailsLoaded(this.shift);
}

class ShiftDetailsError extends ShiftDetailsState {
  final ApiFailure failure;

  ShiftDetailsError(this.failure);
}
