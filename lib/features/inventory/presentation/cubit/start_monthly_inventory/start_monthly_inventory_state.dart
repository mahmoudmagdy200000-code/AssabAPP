import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/start_monthly_inventory_response.dart';

sealed class StartMonthlyInventoryState extends Equatable {
  const StartMonthlyInventoryState();

  @override
  List<Object> get props => [];
}

final class StartMonthlyInventoryInit extends StartMonthlyInventoryState {
  const StartMonthlyInventoryInit();
}

final class StartMonthlyInventoryLoading extends StartMonthlyInventoryState {
  const StartMonthlyInventoryLoading();
}

final class StartMonthlyInventorySuccess extends StartMonthlyInventoryState {
  final StartMonthlyInventoryResponse response;

  const StartMonthlyInventorySuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class StartMonthlyInventoryFailure extends StartMonthlyInventoryState {
  final ApiFailure failure;

  const StartMonthlyInventoryFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
