import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/recurring_order_details_response.dart';

sealed class GetRecurringOrderDetailsState extends Equatable {
  const GetRecurringOrderDetailsState();

  @override
  List<Object> get props => [];
}

final class GetRecurringOrderDetailsInit extends GetRecurringOrderDetailsState {
  const GetRecurringOrderDetailsInit();
}

final class GetRecurringOrderDetailsLoading
    extends GetRecurringOrderDetailsState {
  const GetRecurringOrderDetailsLoading();
}

final class GetRecurringOrderDetailsSuccess
    extends GetRecurringOrderDetailsState {
  final RecurringOrderDetailsResponse details;

  const GetRecurringOrderDetailsSuccess(this.details);

  @override
  List<Object> get props => [details];
}

final class GetRecurringOrderDetailsFailure
    extends GetRecurringOrderDetailsState {
  final ApiFailure failure;

  const GetRecurringOrderDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
