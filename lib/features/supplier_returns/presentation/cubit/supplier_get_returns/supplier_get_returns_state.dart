import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/supplier_returns_response.dart';

sealed class SupplierGetReturnsState extends Equatable {
  const SupplierGetReturnsState();

  @override
  List<Object> get props => [];
}

final class SupplierGetReturnsInit extends SupplierGetReturnsState {
  const SupplierGetReturnsInit();
}

final class SupplierGetReturnsLoading extends SupplierGetReturnsState {
  const SupplierGetReturnsLoading();
}

final class SupplierGetReturnsSuccess extends SupplierGetReturnsState {
  final List<SupplierReturnData> returns;

  const SupplierGetReturnsSuccess(this.returns);

  @override
  List<Object> get props => [returns];
}

final class SupplierGetReturnsFailure extends SupplierGetReturnsState {
  final ApiFailure failure;

  const SupplierGetReturnsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
