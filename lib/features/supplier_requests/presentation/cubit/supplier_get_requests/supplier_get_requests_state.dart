import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/supplier_orders_response.dart';

sealed class SupplierGetRequestsState extends Equatable {
  const SupplierGetRequestsState();

  @override
  List<Object> get props => [];
}

final class SupplierGetRequestsInit extends SupplierGetRequestsState {
  const SupplierGetRequestsInit();
}

final class SupplierGetRequestsLoading extends SupplierGetRequestsState {
  const SupplierGetRequestsLoading();
}

final class SupplierGetRequestsSuccess extends SupplierGetRequestsState {
  final List<SupplierOrder> requests;

  const SupplierGetRequestsSuccess(this.requests);

  @override
  List<Object> get props => [requests];
}

final class SupplierGetRequestsFailure extends SupplierGetRequestsState {
  final ApiFailure failure;

  const SupplierGetRequestsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
