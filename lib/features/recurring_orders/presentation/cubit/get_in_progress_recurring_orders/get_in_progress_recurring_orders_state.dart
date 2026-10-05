import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/recurring_orders_response.dart';

sealed class GetInProgressRecurringOrdersState extends Equatable {
  const GetInProgressRecurringOrdersState();

  @override
  List<Object> get props => [];
}

final class GetInProgressRecurringOrdersInit
    extends GetInProgressRecurringOrdersState {
  const GetInProgressRecurringOrdersInit();
}

final class GetInProgressRecurringOrdersLoading
    extends GetInProgressRecurringOrdersState {
  const GetInProgressRecurringOrdersLoading();
}

final class GetInProgressRecurringOrdersSuccess
    extends GetInProgressRecurringOrdersState {
  final RecurringOrdersResponse orders;

  const GetInProgressRecurringOrdersSuccess(this.orders);

  @override
  List<Object> get props => [orders];
}

final class GetInProgressRecurringOrdersFailure
    extends GetInProgressRecurringOrdersState {
  final ApiFailure failure;

  const GetInProgressRecurringOrdersFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
