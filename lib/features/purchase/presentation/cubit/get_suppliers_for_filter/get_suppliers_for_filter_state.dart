import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/suppliers_for_filter_purchase_items_response.dart';

sealed class GetSuppliersForFilterState extends Equatable {
  const GetSuppliersForFilterState();

  @override
  List<Object> get props => [];
}

final class GetSuppliersForFilterInit extends GetSuppliersForFilterState {
  const GetSuppliersForFilterInit();
}

final class GetSuppliersForFilterLoading extends GetSuppliersForFilterState {
  const GetSuppliersForFilterLoading();
}

final class GetSuppliersForFilterSuccess extends GetSuppliersForFilterState {
  final List<SuppliersForFilterPurchaseItemsResponseData> suppliers;

  const GetSuppliersForFilterSuccess(this.suppliers);

  @override
  List<Object> get props => [suppliers];
}

final class GetSuppliersForFilterFailure extends GetSuppliersForFilterState {
  final ApiFailure failure;

  const GetSuppliersForFilterFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
