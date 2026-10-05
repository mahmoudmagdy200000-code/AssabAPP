import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../../returns_management/data/models/return_goods_response.dart';

sealed class GetPendingEscelationsState extends Equatable {
  const GetPendingEscelationsState();

  @override
  List<Object> get props => [];
}

final class GetPendingEscelationsInit extends GetPendingEscelationsState {
  const GetPendingEscelationsInit();
}

final class GetPendingEscelationsLoading extends GetPendingEscelationsState {
  const GetPendingEscelationsLoading();
}

final class GetPendingEscelationsSuccess extends GetPendingEscelationsState {
  final ReturnGoodsResponse returns;

  const GetPendingEscelationsSuccess(this.returns);

  @override
  List<Object> get props => [returns];
}

final class GetPendingEscelationsFailure extends GetPendingEscelationsState {
  final ApiFailure failure;
  const GetPendingEscelationsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
