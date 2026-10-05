import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/personal_custody_transactions_response.dart';

sealed class GetPersonalBalanceTransactionsState extends Equatable {
  const GetPersonalBalanceTransactionsState();

  @override
  List<Object> get props => [];
}

final class GetPersonalBalanceTransactionsInit
    extends GetPersonalBalanceTransactionsState {
  const GetPersonalBalanceTransactionsInit();
}

final class GetPersonalBalanceTransactionsLoading
    extends GetPersonalBalanceTransactionsState {
  const GetPersonalBalanceTransactionsLoading();
}

final class GetPersonalBalanceTransactionsSuccess
    extends GetPersonalBalanceTransactionsState {
  final PersonalCustodyTransactionsResponse response;

  const GetPersonalBalanceTransactionsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetPersonalBalanceTransactionsFailure
    extends GetPersonalBalanceTransactionsState {
  final ApiFailure failure;

  const GetPersonalBalanceTransactionsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
