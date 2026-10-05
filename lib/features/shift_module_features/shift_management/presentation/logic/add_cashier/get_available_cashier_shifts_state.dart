part of 'get_available_cashier_shifts_cubit.dart';

@immutable
abstract class GetAvailableCashierShiftsState {}

class GetAvailableCashierShiftsInitial extends GetAvailableCashierShiftsState {}

class GetAvailableCashierShiftsLoading extends GetAvailableCashierShiftsState {}

class GetAvailableCashierShiftsFailure extends GetAvailableCashierShiftsState {
  final ApiFailure failure;

  GetAvailableCashierShiftsFailure(this.failure);
}

class GetAvailableCashierShiftsSuccess<T>
    extends GetAvailableCashierShiftsState {
  final List<T> shifts;

  GetAvailableCashierShiftsSuccess(this.shifts);
}

class GetAvailableCashierShiftsEmpty extends GetAvailableCashierShiftsState {}
