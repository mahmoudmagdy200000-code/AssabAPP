import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/supplier_order_modification_response.dart';

sealed class SupplierGetModificationState extends Equatable {
  const SupplierGetModificationState();

  @override
  List<Object> get props => [];
}

final class SupplierGetModificationInit extends SupplierGetModificationState {
  const SupplierGetModificationInit();
}

final class SupplierGetModificationLoading
    extends SupplierGetModificationState {
  const SupplierGetModificationLoading();
}

final class SupplierGetModificationSuccess
    extends SupplierGetModificationState {
  final SupplierOrderModificationResponse data;

  const SupplierGetModificationSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class SupplierGetModificationFailure
    extends SupplierGetModificationState {
  final ApiFailure failure;

  const SupplierGetModificationFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
