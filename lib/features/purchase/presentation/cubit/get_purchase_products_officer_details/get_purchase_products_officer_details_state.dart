import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../data/models/purchase_product_officer_details_response.dart';

sealed class GetPurchaseProductsOfficerDetailsState extends Equatable {
  const GetPurchaseProductsOfficerDetailsState();

  @override
  List<Object> get props => [];
}

final class GetPurchaseProductsOfficerDetailsInit
    extends GetPurchaseProductsOfficerDetailsState {
  const GetPurchaseProductsOfficerDetailsInit();
}

final class GetPurchaseProductsOfficerDetailsLoading
    extends GetPurchaseProductsOfficerDetailsState {
  const GetPurchaseProductsOfficerDetailsLoading();
}

final class GetPurchaseProductsOfficerDetailsSuccess
    extends GetPurchaseProductsOfficerDetailsState {
  final List<PurchaseProductOfficerDetailsData> products;

  const GetPurchaseProductsOfficerDetailsSuccess(this.products);

  @override
  List<Object> get props => [products];
}

final class GetPurchaseProductsOfficerDetailsFailure
    extends GetPurchaseProductsOfficerDetailsState {
  final ApiFailure failure;

  const GetPurchaseProductsOfficerDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
