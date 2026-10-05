import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/custody_trend_balance_state_response.dart';

sealed class GetCustodyTrendStateState extends Equatable {
  const GetCustodyTrendStateState();

  @override
  List<Object> get props => [];
}

final class GetCustodyTrendStateInit extends GetCustodyTrendStateState {
  const GetCustodyTrendStateInit();
}

final class GetCustodyTrendStateLoading extends GetCustodyTrendStateState {
  const GetCustodyTrendStateLoading();
}

final class GetCustodyTrendStateSuccess extends GetCustodyTrendStateState {
  final CustodyTrendBalanceStateResponse response;

  const GetCustodyTrendStateSuccess(this.response);
  @override
  List<Object> get props => [response];
}

final class GetCustodyTrendStateFailure extends GetCustodyTrendStateState {
  final ApiFailure failure;

  const GetCustodyTrendStateFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
