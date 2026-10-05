import 'package:assab/features/branch_manager_requests/data/models/orders_response.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';

sealed class GetOrdersState extends Equatable {
  const GetOrdersState();

  @override
  List<Object> get props => [];
}

final class GetOrdersInit extends GetOrdersState {
  const GetOrdersInit();
}

final class GetOrdersLoading extends GetOrdersState {
  const GetOrdersLoading();
}

final class GetOrdersSuccess extends GetOrdersState {
  final List<OrderData> orders;

  const GetOrdersSuccess(this.orders);

  @override
  List<Object> get props => [orders];
}

final class GetOrdersFailure extends GetOrdersState {
  final ApiFailure failure;

  const GetOrdersFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
