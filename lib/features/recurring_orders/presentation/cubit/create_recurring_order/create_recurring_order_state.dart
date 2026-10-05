import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class CreateRecurringOrderState extends Equatable {
  const CreateRecurringOrderState();

  @override
  List<Object> get props => [];
}

final class CreateRecurringOrderInit extends CreateRecurringOrderState {
  const CreateRecurringOrderInit();
}

final class CreateRecurringOrderLoading extends CreateRecurringOrderState {
  const CreateRecurringOrderLoading();
}

final class CreateRecurringOrderSuccess extends CreateRecurringOrderState {
  const CreateRecurringOrderSuccess();
}

final class CreateRecurringOrderFailure extends CreateRecurringOrderState {
  final ApiFailure failure;

  const CreateRecurringOrderFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
