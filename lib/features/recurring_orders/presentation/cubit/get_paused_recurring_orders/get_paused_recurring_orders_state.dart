import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/recurring_orders_response.dart';

sealed class GetPausedRecurringOrdersState extends Equatable {
  const GetPausedRecurringOrdersState();

  @override
  List<Object> get props => [];
}

final class GetPausedRecurringOrdersInit extends GetPausedRecurringOrdersState {
  const GetPausedRecurringOrdersInit();
}

final class GetPausedRecurringOrdersLoading
    extends GetPausedRecurringOrdersState {
  const GetPausedRecurringOrdersLoading();
}

final class GetPausedRecurringOrdersSuccess
    extends GetPausedRecurringOrdersState {
  final RecurringOrdersResponse orders;

  const GetPausedRecurringOrdersSuccess(this.orders);

  @override
  List<Object> get props => [orders];
}

final class GetPausedRecurringOrdersFailure
    extends GetPausedRecurringOrdersState {
  final ApiFailure failure;

  const GetPausedRecurringOrdersFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
