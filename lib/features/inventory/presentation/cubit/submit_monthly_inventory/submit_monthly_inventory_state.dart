import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';

sealed class SubmitMonthlyInventoryState extends Equatable {
  const SubmitMonthlyInventoryState();

  @override
  List<Object> get props => [];
}

final class SubmitMonthlyInventoryInit extends SubmitMonthlyInventoryState {
  const SubmitMonthlyInventoryInit();
}

final class SubmitMonthlyInventoryLoading extends SubmitMonthlyInventoryState {
  const SubmitMonthlyInventoryLoading();
}

final class SubmitMonthlyInventorySuccess extends SubmitMonthlyInventoryState {
  const SubmitMonthlyInventorySuccess();
}

final class SubmitMonthlyInventoryFailure extends SubmitMonthlyInventoryState {
  final ApiFailure failure;
  const SubmitMonthlyInventoryFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
