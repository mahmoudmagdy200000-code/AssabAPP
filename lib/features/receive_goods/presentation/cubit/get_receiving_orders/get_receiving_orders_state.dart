import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/receive_goods_in_progress_orders_response.dart';

sealed class GetReceivingOrdersState extends Equatable {
  const GetReceivingOrdersState();

  @override
  List<Object> get props => [];
}

final class GetReceivingOrdersInit extends GetReceivingOrdersState {
  const GetReceivingOrdersInit();
}

final class GetReceivingOrdersInProgressLoading
    extends GetReceivingOrdersState {
  const GetReceivingOrdersInProgressLoading();
}

final class GetReceivingOrdersInProgressSuccess
    extends GetReceivingOrdersState {
  final List<ReceiveGoodsOrder> orders;

  const GetReceivingOrdersInProgressSuccess(this.orders);

  @override
  List<Object> get props => [orders];
}

final class GetReceivingOrdersInProgressFailure
    extends GetReceivingOrdersState {
  final ApiFailure failure;

  const GetReceivingOrdersInProgressFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class GetReceivingOrdersMissingLoading extends GetReceivingOrdersState {
  const GetReceivingOrdersMissingLoading();
}

final class GetReceivingOrdersMissingSuccess extends GetReceivingOrdersState {
  final List<ReceiveGoodsOrder> orders;

  const GetReceivingOrdersMissingSuccess(this.orders);

  @override
  List<Object> get props => [orders];
}

final class GetReceivingOrdersMissingFailure extends GetReceivingOrdersState {
  final ApiFailure failure;

  const GetReceivingOrdersMissingFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class GetReceivingOrdersCompletedLoading extends GetReceivingOrdersState {
  const GetReceivingOrdersCompletedLoading();
}

final class GetReceivingOrdersCompletedSuccess extends GetReceivingOrdersState {
  final List<ReceiveGoodsOrder> orders;

  const GetReceivingOrdersCompletedSuccess(this.orders);

  @override
  List<Object> get props => [orders];
}

final class GetReceivingOrdersCompletedFailure extends GetReceivingOrdersState {
  final ApiFailure failure;

  const GetReceivingOrdersCompletedFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
