part of 'start_cashier_shift_cubit.dart';

@immutable
sealed class StartCashierShiftState {}

final class StartCashierShiftInitial extends StartCashierShiftState {}

final class StartCashierShiftLoading extends StartCashierShiftState {
  final String? loadingShiftId;

  StartCashierShiftLoading(this.loadingShiftId);
}

final class StartCashierShiftFailure extends StartCashierShiftState {
  final ApiFailure failure;

  StartCashierShiftFailure(this.failure);
}

final class StartCashierShiftSuccess extends StartCashierShiftState {}
