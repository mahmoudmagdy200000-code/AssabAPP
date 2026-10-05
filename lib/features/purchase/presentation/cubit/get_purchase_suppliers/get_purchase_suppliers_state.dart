import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/purchase_suppliers_response.dart';

sealed class GetPurchaseSuppliersState extends Equatable {
  const GetPurchaseSuppliersState();

  @override
  List<Object> get props => [];
}

final class GetPurchaseSuppliersInit extends GetPurchaseSuppliersState {
  const GetPurchaseSuppliersInit();
}

final class GetPurchaseSuppliersLoading extends GetPurchaseSuppliersState {
  const GetPurchaseSuppliersLoading();
}

final class GetPurchaseSuppliersSuccess extends GetPurchaseSuppliersState {
  final PurchaseSuppliersResponse response;

  const GetPurchaseSuppliersSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetPurchaseSuppliersFailure extends GetPurchaseSuppliersState {
  final ApiFailure failure;

  const GetPurchaseSuppliersFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
