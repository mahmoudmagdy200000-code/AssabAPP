import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/custody_personal_balance_response.dart';

sealed class GetPersonalBalanceState extends Equatable {
  const GetPersonalBalanceState();

  @override
  List<Object> get props => [];
}

final class GetPersonalBalanceInit extends GetPersonalBalanceState {
  const GetPersonalBalanceInit();
}

final class GetPersonalBalanceLoading extends GetPersonalBalanceState {
  const GetPersonalBalanceLoading();
}

final class GetPersonalBalanceSuccess extends GetPersonalBalanceState {
  final CustodyPersonalBalanceResponse balance;

  const GetPersonalBalanceSuccess(this.balance);

  @override
  List<Object> get props => [balance];
}

final class GetPersonalBalanceFailure extends GetPersonalBalanceState {
  final ApiFailure failure;

  const GetPersonalBalanceFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
