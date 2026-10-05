import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/recurring_orders_response.dart';

sealed class GetNextScheduledRecurringOrdersState extends Equatable {
  const GetNextScheduledRecurringOrdersState();

  @override
  List<Object> get props => [];
}

final class GetNextScheduledRecurringOrdersInit
    extends GetNextScheduledRecurringOrdersState {
  const GetNextScheduledRecurringOrdersInit();
}

final class GetNextScheduledRecurringOrdersLoading
    extends GetNextScheduledRecurringOrdersState {
  const GetNextScheduledRecurringOrdersLoading();
}

final class GetNextScheduledRecurringOrdersSuccess
    extends GetNextScheduledRecurringOrdersState {
  final RecurringOrdersResponse orders;

  const GetNextScheduledRecurringOrdersSuccess(this.orders);

  @override
  List<Object> get props => [orders];
}

final class GetNextScheduledRecurringOrdersFailure
    extends GetNextScheduledRecurringOrdersState {
  final ApiFailure failure;

  const GetNextScheduledRecurringOrdersFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
