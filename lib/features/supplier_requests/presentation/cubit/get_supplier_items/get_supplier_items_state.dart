import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/supplier_items_response.dart';

sealed class GetSupplierItemsState extends Equatable {
  @override
  List<Object> get props => [];
}

final class GetSupplierItemsInit extends GetSupplierItemsState {
  GetSupplierItemsInit();
}

final class GetSupplierItemsLoading extends GetSupplierItemsState {
  GetSupplierItemsLoading();
}

final class GetSupplierItemsSuccess extends GetSupplierItemsState {
  final List<SupplierItem> items;

  GetSupplierItemsSuccess(this.items);

  @override
  List<Object> get props => [items];
}

final class GetSupplierItemsFailure extends GetSupplierItemsState {
  final ApiFailure failure;

  GetSupplierItemsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
