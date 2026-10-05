import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/monthly_inventory_completed_products_response.dart';

sealed class GetMonthlyCompletedProductsState extends Equatable {
  const GetMonthlyCompletedProductsState();

  @override
  List<Object> get props => [];
}

final class GetMonthlyCompletedProductsInit
    extends GetMonthlyCompletedProductsState {
  const GetMonthlyCompletedProductsInit();
}

final class GetMonthlyCompletedProductsLoading
    extends GetMonthlyCompletedProductsState {
  const GetMonthlyCompletedProductsLoading();
}

final class GetMonthlyCompletedProductsSuccess
    extends GetMonthlyCompletedProductsState {
  final MonthlyInventoryCompletedProductsResponse response;

  const GetMonthlyCompletedProductsSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

final class GetMonthlyCompletedProductsFailure
    extends GetMonthlyCompletedProductsState {
  final ApiFailure failure;

  const GetMonthlyCompletedProductsFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
