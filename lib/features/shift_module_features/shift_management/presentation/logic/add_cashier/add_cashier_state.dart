part of 'add_cashier_cubit.dart';

@immutable
sealed class AddCashierState {}

final class AddCashierInitial extends AddCashierState {}

final class CashierShiftsLoading extends AddCashierState {}

final class AddCashierLoading extends AddCashierState {}

final class AddCashierSuccess extends AddCashierState {}

final class CashierFetchDataFailure extends AddCashierState {
  final ApiFailure failure;
  CashierFetchDataFailure(this.failure);
}

final class AddCashierEmpty extends AddCashierState {}

final class AddCashierFailure extends AddCashierState {
  final ApiFailure failure;

  AddCashierFailure(this.failure);
}

final class CashierFetchDataSuccess<T> extends AddCashierState {
  final List<T> data;

  CashierFetchDataSuccess(this.data);
}

final class CashierFetchDataLoading extends AddCashierState {}

final class CheckEmailInvalid extends AddCashierState {
  final ApiFailure failure;

  CheckEmailInvalid(this.failure);
}

final class CheckEmailValid extends AddCashierState {}

final class AddCashierValuesUpdated extends AddCashierState {}
