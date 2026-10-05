part of 'cashier_management_cubit.dart';

@immutable
sealed class CashierManagementState {}

final class CashierManagementInitial extends CashierManagementState {}

final class CashierManagementLoading extends CashierManagementState {}

final class CashierManagementEmpty extends CashierManagementState {
  final bool fromFilter;
  CashierManagementEmpty({required this.fromFilter});
}

final class CashierManagementSuccess extends CashierManagementState {
  final List<CashierEntity> cashiers;
  CashierManagementSuccess(this.cashiers);
}

final class CashierManagementFailure extends CashierManagementState {
  final ApiFailure failure;

  CashierManagementFailure(this.failure);
}
