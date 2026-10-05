import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class UpdateQtyMonthlyInventoryState extends Equatable {
  const UpdateQtyMonthlyInventoryState();

  @override
  List<Object> get props => [];
}

final class UpdateQtyMonthlyInventoryInit
    extends UpdateQtyMonthlyInventoryState {
  const UpdateQtyMonthlyInventoryInit();
}

final class UpdateQtyMonthlyInventoryLoading
    extends UpdateQtyMonthlyInventoryState {
  const UpdateQtyMonthlyInventoryLoading();
}

final class UpdateQtyMonthlyInventorySuccess
    extends UpdateQtyMonthlyInventoryState {
  const UpdateQtyMonthlyInventorySuccess();
}

final class UpdateQtyMonthlyInventoryFailure
    extends UpdateQtyMonthlyInventoryState {
  final ApiFailure failure;

  const UpdateQtyMonthlyInventoryFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
