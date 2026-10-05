import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/brand_owner_requests_models.dart';

sealed class BrandOwnerRequestsCustodySalesTransfersState extends Equatable {
  const BrandOwnerRequestsCustodySalesTransfersState();

  @override
  List<Object> get props => [];
}

final class BrandOwnerRequestsCustodySalesTransfersInitial
    extends BrandOwnerRequestsCustodySalesTransfersState {
  const BrandOwnerRequestsCustodySalesTransfersInitial();
}

final class BrandOwnerRequestsCustodySalesTransfersLoading
    extends BrandOwnerRequestsCustodySalesTransfersState {
  const BrandOwnerRequestsCustodySalesTransfersLoading();
}

final class BrandOwnerRequestsCustodySalesTransfersSuccess
    extends BrandOwnerRequestsCustodySalesTransfersState {
  final List<BrandOwnerSalesTransferItemModel> response;

  const BrandOwnerRequestsCustodySalesTransfersSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class BrandOwnerSalesTransferDetailsSuccess
    extends BrandOwnerRequestsCustodySalesTransfersState {
  final BrandOwnerSalesTransferDetailsModel details;

  const BrandOwnerSalesTransferDetailsSuccess(this.details);

  @override
  List<Object> get props => [details];
}

final class BrandOwnerRequestsCustodySalesTransfersFailure
    extends BrandOwnerRequestsCustodySalesTransfersState {
  final ApiFailure failure;

  const BrandOwnerRequestsCustodySalesTransfersFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
