import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class CustodyGetPersonalBalanceOnlyState extends Equatable {
  const CustodyGetPersonalBalanceOnlyState();

  @override
  List<Object> get props => [];
}

final class CustodyGetPersonalBalanceOnlyInit
    extends CustodyGetPersonalBalanceOnlyState {
  const CustodyGetPersonalBalanceOnlyInit();
}

final class CustodyGetPersonalBalanceOnlyLoading
    extends CustodyGetPersonalBalanceOnlyState {
  const CustodyGetPersonalBalanceOnlyLoading();
}

final class CustodyGetPersonalBalanceOnlySuccess
    extends CustodyGetPersonalBalanceOnlyState {
  final double balance;

  const CustodyGetPersonalBalanceOnlySuccess(this.balance);
}

final class CustodyGetPersonalBalanceOnlyFailure
    extends CustodyGetPersonalBalanceOnlyState {
  final ApiFailure failure;

  const CustodyGetPersonalBalanceOnlyFailure(this.failure);
}
