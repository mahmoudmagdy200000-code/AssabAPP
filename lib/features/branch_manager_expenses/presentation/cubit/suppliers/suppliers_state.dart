import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/branch_manager_expenses/data/models/supplier_response_model.dart';
import 'package:equatable/equatable.dart';

sealed class SuppliersState extends Equatable {
  const SuppliersState();

  @override
  List<Object> get props => [];
}

final class SuppliersInitial extends SuppliersState {
  const SuppliersInitial();
}

final class SuppliersLoading extends SuppliersState {
  const SuppliersLoading();
}

final class SuppliersSuccess extends SuppliersState {
  final SupplierResponseModel suppliers;

  const SuppliersSuccess(this.suppliers);

  @override
  List<Object> get props => [suppliers];
}

final class SuppliersFailure extends SuppliersState {
  final ApiFailure failure;

  const SuppliersFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class SelectSupplier extends SuppliersState {
  final String supplierId;
  final String supplierName;

  const SelectSupplier(this.supplierId, this.supplierName);

  @override
  List<Object> get props => [supplierId, supplierName];
}
