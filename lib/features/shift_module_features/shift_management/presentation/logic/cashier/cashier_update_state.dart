part of 'cashier_update_cubit.dart';

@immutable
sealed class CashierUpdateState {}

final class CashierDetailsInitial extends CashierUpdateState {}

final class CashierUpdateLoading extends CashierUpdateState {}

final class CashierDetailsFetchSuccess extends CashierUpdateState {
  final bool? openedFromChangeShiftButton;
  final CashierEntity? cashier;
  CashierDetailsFetchSuccess({this.openedFromChangeShiftButton, this.cashier});
}

final class CashierDetailsFetchLoading extends CashierUpdateState {}

final class CashierUpdateSuccess extends CashierUpdateState {
  final bool? openedFromChangeShiftButton;
  final CashierEntity? cashier;
  CashierUpdateSuccess({this.openedFromChangeShiftButton, this.cashier});
}

final class CashierDetailsFetchFailure extends CashierUpdateState {
  final ApiFailure failure;

  CashierDetailsFetchFailure(this.failure);
}

final class CashierUpdateFailure extends CashierUpdateState {
  final ApiFailure failure;

  CashierUpdateFailure(this.failure);
}
