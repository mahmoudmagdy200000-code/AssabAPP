import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/cashier_info_response.dart';

sealed class GetCashierInfoState extends Equatable {
  const GetCashierInfoState();

  @override
  List<Object> get props => [];
}

final class GetCashierInfoInit extends GetCashierInfoState {
  const GetCashierInfoInit();
}

final class GetCashierInfoLoading extends GetCashierInfoState {
  const GetCashierInfoLoading();
}

final class GetCashierInfoSuccess extends GetCashierInfoState {
  final CashierInfoResponse response;

  const GetCashierInfoSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

final class GetCashierInfoFailure extends GetCashierInfoState {
  final ApiFailure failure;

  const GetCashierInfoFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
