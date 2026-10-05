import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/monthly_inventory_details_response.dart';

sealed class GetMonthlyDetailsState extends Equatable {
  const GetMonthlyDetailsState();

  @override
  List<Object> get props => [];
}

final class GetMonthlyDetailsInit extends GetMonthlyDetailsState {
  const GetMonthlyDetailsInit();
}

final class GetMonthlyDetailsLoading extends GetMonthlyDetailsState {
  const GetMonthlyDetailsLoading();
}

final class GetMonthlyDetailsSuccess extends GetMonthlyDetailsState {
  final MonthlyInventoryDetailsResponse response;

  const GetMonthlyDetailsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetMonthlyDetailsFailure extends GetMonthlyDetailsState {
  final ApiFailure failure;

  const GetMonthlyDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
