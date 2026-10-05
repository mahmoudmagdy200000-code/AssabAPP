import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/purchase_supplier_product_details_response.dart';

sealed class GetPurchaseProductsSupplierDetailsState extends Equatable {
  const GetPurchaseProductsSupplierDetailsState();

  @override
  List<Object> get props => [];
}

final class GetPurchaseProductsSupplierDetailsInit
    extends GetPurchaseProductsSupplierDetailsState {
  const GetPurchaseProductsSupplierDetailsInit();
}

final class GetPurchaseProductsSupplierDetailsLoading
    extends GetPurchaseProductsSupplierDetailsState {
  const GetPurchaseProductsSupplierDetailsLoading();
}

final class GetPurchaseProductsSupplierDetailsSuccess
    extends GetPurchaseProductsSupplierDetailsState {
  final PurchaseSupplierProductDetailsResponse details;

  const GetPurchaseProductsSupplierDetailsSuccess(this.details);

  @override
  List<Object> get props => [details];
}

final class GetPurchaseProductsSupplierDetailsFailure
    extends GetPurchaseProductsSupplierDetailsState {
  final ApiFailure failure;

  const GetPurchaseProductsSupplierDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
