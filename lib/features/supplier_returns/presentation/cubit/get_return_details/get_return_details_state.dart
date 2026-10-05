import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/supplier_return_goods_details_response.dart';

sealed class SupplierGetReturnDetailsState extends Equatable {
  const SupplierGetReturnDetailsState();

  @override
  List<Object> get props => [];
}

final class SupplierGetReturnDetailsInit extends SupplierGetReturnDetailsState {
  const SupplierGetReturnDetailsInit();
}

final class SupplierGetReturnDetailsLoading
    extends SupplierGetReturnDetailsState {
  const SupplierGetReturnDetailsLoading();
}

final class SupplierGetReturnDetailsSuccess
    extends SupplierGetReturnDetailsState {
  final SupplierReturnGoodsDetailsResponse returnDetails;

  const SupplierGetReturnDetailsSuccess(this.returnDetails);

  @override
  List<Object> get props => [returnDetails];
}

final class SupplierGetReturnDetailsFailure
    extends SupplierGetReturnDetailsState {
  final ApiFailure failure;

  const SupplierGetReturnDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
