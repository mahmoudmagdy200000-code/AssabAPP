part of 'end_manager_shift_cubit.dart';

@immutable
sealed class EndAndUpdateManagerShiftState {}

final class EndManagerShiftInitial extends EndAndUpdateManagerShiftState {}

final class EndManagerShiftButtonLoading
    extends EndAndUpdateManagerShiftState {}

final class EndManagerShiftSuccess extends EndAndUpdateManagerShiftState {
  final ManagerShiftEndDataEntity managerShift;

  EndManagerShiftSuccess({required this.managerShift});
}

final class EndManagerShiftFailure extends EndAndUpdateManagerShiftState {
  final ApiFailure failure;

  EndManagerShiftFailure(this.failure);
}
