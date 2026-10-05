import 'package:equatable/equatable.dart';

import '../../../../../../core/errors/api_failure.dart';
import '../../../domain/entity/cashier_entity.dart';

sealed class GetCashierState extends Equatable {
  const GetCashierState();

  @override
  List<Object> get props => [];
}

final class GetCashierInitial extends GetCashierState {
  const GetCashierInitial();
}

final class GetCashierLoading extends GetCashierState {
  const GetCashierLoading();
}

final class GetCashierSuccess extends GetCashierState {
  final List<CashierEntity> cashier;

  const GetCashierSuccess(this.cashier);

  @override
  List<Object> get props => [cashier];
}

final class GetCashierFailure extends GetCashierState {
  final ApiFailure failure;

  const GetCashierFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
