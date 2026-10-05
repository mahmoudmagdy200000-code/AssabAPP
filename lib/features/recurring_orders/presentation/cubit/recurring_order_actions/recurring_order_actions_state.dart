import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';

sealed class RecurringOrderActionsState extends Equatable {
  const RecurringOrderActionsState();

  @override
  List<Object> get props => [];
}

final class RecurringOrderActionsInit extends RecurringOrderActionsState {
  const RecurringOrderActionsInit();
}

final class RecurringOrderActionsLoading extends RecurringOrderActionsState {
  const RecurringOrderActionsLoading();
}

final class RecurringOrderActionsSuccess extends RecurringOrderActionsState {
  const RecurringOrderActionsSuccess();
}

final class RecurringOrderActionsFailure extends RecurringOrderActionsState {
  final ApiFailure failure;

  const RecurringOrderActionsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
