part of 'manager_shift_cubit.dart';

@immutable
sealed class ManagerShiftState {}

final class ManagerShiftInitial extends ManagerShiftState {}

final class ManagerShiftButtonLoading extends ManagerShiftState {}
// final class ManagerShiftButtonSuccess extends ManagerShiftState {}
// final class ManagerShiftButtonFailure extends ManagerShiftState {
//   final ApiFailure failure;
//
//   ManagerShiftButtonFailure(this.failure);
// }

final class ManagerShiftLoading extends ManagerShiftState {}

final class CashierHandoverDetailsLoading extends ManagerShiftState {}

final class CashierHandoverDetailsLoaded extends ManagerShiftState {
  final CashierHandoverDetailsEntity handoverDetails;

  CashierHandoverDetailsLoaded({required this.handoverDetails});
}

final class CashierHandoverDetailsLoadingFailure extends ManagerShiftState {
  final ApiFailure failure;

  CashierHandoverDetailsLoadingFailure(this.failure);
}

final class ManagerShiftLoaded extends ManagerShiftState {
  final ManagerShiftEntity managerShift;
  final ProgressEntity shiftProgress;

  ManagerShiftLoaded({required this.managerShift, required this.shiftProgress});
}

final class ManagerShiftFailure extends ManagerShiftState {
  final ApiFailure failure;

  ManagerShiftFailure(this.failure);
}
