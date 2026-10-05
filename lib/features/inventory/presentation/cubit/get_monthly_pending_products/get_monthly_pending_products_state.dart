import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/monthly_inventory_pending_products_response.dart';

sealed class GetMonthlyPendingProductsState extends Equatable {
  const GetMonthlyPendingProductsState();

  @override
  List<Object> get props => [];
}

final class GetMonthlyPendingProductsInit
    extends GetMonthlyPendingProductsState {
  const GetMonthlyPendingProductsInit();
}

final class GetMonthlyPendingProductsLoading
    extends GetMonthlyPendingProductsState {
  const GetMonthlyPendingProductsLoading();
}

final class GetMonthlyPendingProductsSuccess
    extends GetMonthlyPendingProductsState {
  final MonthlyInventoryPendingProductsResponse response;

  const GetMonthlyPendingProductsSuccess({required this.response});

  @override
  List<Object> get props => [response];

  GetMonthlyPendingProductsSuccess copyWith({
    MonthlyInventoryPendingProductsResponse? response,
  }) {
    return GetMonthlyPendingProductsSuccess(
      response: response ?? this.response,
    );
  }
}

final class GetMonthlyPendingProductsFailure
    extends GetMonthlyPendingProductsState {
  final ApiFailure failure;

  const GetMonthlyPendingProductsFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
