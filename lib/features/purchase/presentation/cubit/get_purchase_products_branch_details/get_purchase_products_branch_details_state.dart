import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/purchase_product_branch_details_response.dart';

sealed class GetPurchaseProductsBranchDetailsState extends Equatable {
  const GetPurchaseProductsBranchDetailsState();

  @override
  List<Object> get props => [];
}

final class GetPurchaseProductsBranchDetailsInit
    extends GetPurchaseProductsBranchDetailsState {
  const GetPurchaseProductsBranchDetailsInit();
}

final class GetPurchaseProductsBranchDetailsLoading
    extends GetPurchaseProductsBranchDetailsState {
  const GetPurchaseProductsBranchDetailsLoading();
}

final class GetPurchaseProductsBranchDetailsSuccess
    extends GetPurchaseProductsBranchDetailsState {
  final PurchaseProductBranchDetailsResponse
  purchaseProductBranchDetailsResponse;

  const GetPurchaseProductsBranchDetailsSuccess(
    this.purchaseProductBranchDetailsResponse,
  );

  @override
  List<Object> get props => [purchaseProductBranchDetailsResponse];
}

final class GetPurchaseProductsBranchDetailsFailure
    extends GetPurchaseProductsBranchDetailsState {
  final ApiFailure failure;

  const GetPurchaseProductsBranchDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
