part of 'end_shift_cubit.dart';

class EndShiftState extends Equatable {
  const EndShiftState({this.varianceStrategy});

  final VarianceUiStrategy? varianceStrategy;
  EndShiftState copyWith({VarianceUiStrategy? varianceStrategy}) {
    return EndShiftState(
      varianceStrategy: varianceStrategy ?? this.varianceStrategy,
    );
  }

  @override
  List<Object?> get props => [varianceStrategy];
}

class EndShiftInitial extends EndShiftState {}

class EndShiftLoading extends EndShiftState {
  const EndShiftLoading({super.varianceStrategy});
}

class EndShiftSuccess extends EndShiftState {}

class EndShiftHandOverValuesUpdated extends EndShiftState {
  final double handOverAmount;
  final HandoverUserItem? cashier;

  const EndShiftHandOverValuesUpdated({
    required this.handOverAmount,
    this.cashier,
  });

  @override
  List<Object?> get props => [handOverAmount, cashier];
}

class EndShiftTotalSalesValuesUpdated extends EndShiftState {
  final double totalSales;
  final double cashCollected;
  final double cardPayments;
  final List<TotalSalesAggregatorEntity> aggregators;

  const EndShiftTotalSalesValuesUpdated({
    required this.totalSales,
    required this.cashCollected,
    required this.cardPayments,
    required this.aggregators,
  });

  @override
  List<Object?> get props => [
    totalSales,
    cashCollected,
    cardPayments,
    aggregators,
  ];
}

class EndShiftFailure extends EndShiftState {
  final ApiFailure failure;

  const EndShiftFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
