part of 'reassign_shift_cubit.dart';

@immutable
sealed class ReassignShiftState {}

final class ReassignShiftInitial extends ReassignShiftState {}

final class ReassignShiftLoading extends ReassignShiftState {}

final class ReassignShiftSuccess extends ReassignShiftState {}

final class ReassignShiftEmpty extends ReassignShiftState {}

final class ReassignShiftFetchAvailableSuccess extends ReassignShiftState {}

final class ReassignShiftFetchAvailableLoading extends ReassignShiftState {}

final class ReassignShiftFetchAvailableEmpty extends ReassignShiftState {}

final class ReassignShiftFetchAvailableFailure extends ReassignShiftState {
  final ApiFailure failure;

  ReassignShiftFetchAvailableFailure(this.failure);
}

final class ReassignShiftFailure extends ReassignShiftState {
  final ApiFailure failure;

  ReassignShiftFailure(this.failure);
}

class ReassignTotalSalesValuesUpdated extends ReassignShiftState {
  final double totalSales;
  final double cashCollected;
  final double cardPayments;
  final double handOverAmount;
  final List<TotalSalesAggregatorEntity> aggregators;

  ReassignTotalSalesValuesUpdated({
    required this.totalSales,
    required this.cashCollected,
    required this.cardPayments,
    required this.aggregators,
    required this.handOverAmount,
  });

  List<Object?> get props => [
    totalSales,
    cashCollected,
    cardPayments,
    handOverAmount,
    aggregators,
  ];
}

class ReassignChooseEmployeeValuesUpdated extends ReassignShiftState {
  final AvailableCashierEntity selectedCashier;
  ReassignChooseEmployeeValuesUpdated({required this.selectedCashier});

  List<Object?> get props => [selectedCashier];
}
