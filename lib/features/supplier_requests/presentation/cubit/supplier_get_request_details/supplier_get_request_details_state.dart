import 'package:assab/features/supplier_requests/data/models/supplier_order_details_response.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';

sealed class SupplierGetRequestDetailsState extends Equatable {
  const SupplierGetRequestDetailsState();

  @override
  List<Object> get props => [];
}

final class SupplierGetRequestDetailsInit
    extends SupplierGetRequestDetailsState {
  const SupplierGetRequestDetailsInit();
}

final class SupplierGetRequestDetailsLoading
    extends SupplierGetRequestDetailsState {
  const SupplierGetRequestDetailsLoading();
}

final class SupplierGetRequestDetailsSuccess
    extends SupplierGetRequestDetailsState {
  final SupplierOrderDetailsResponse details;

  const SupplierGetRequestDetailsSuccess(this.details);

  @override
  List<Object> get props => [details];
}

final class SupplierGetRequestDetailsFailure
    extends SupplierGetRequestDetailsState {
  final ApiFailure failure;

  const SupplierGetRequestDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
