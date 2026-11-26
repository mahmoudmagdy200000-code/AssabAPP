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
  final int total;
  final String? statusFilter;
  final String? dateFrom;
  final String? dateTo;

  const SupplierGetRequestsSuccess(
    this.requests, {
    this.total = 0,
    this.statusFilter,
    this.dateFrom,
    this.dateTo,
  });

  @override
  List<Object> get props => [
    requests,
    total,
    statusFilter ?? '',
    dateFrom ?? '',
    dateTo ?? '',
  ];
}

final class SupplierGetRequestsFailure extends SupplierGetRequestsState {
  final ApiFailure failure;

  const SupplierGetRequestsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
