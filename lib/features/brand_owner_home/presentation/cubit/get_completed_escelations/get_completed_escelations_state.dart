import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../../returns_management/data/models/return_goods_response.dart';

sealed class GetCompletedEscelationsState extends Equatable {
  const GetCompletedEscelationsState();

  @override
  List<Object> get props => [];
}

final class GetCompletedEscelationsInit extends GetCompletedEscelationsState {
  const GetCompletedEscelationsInit();
}

final class GetCompletedEscelationsLoading
    extends GetCompletedEscelationsState {
  const GetCompletedEscelationsLoading();
}

final class GetCompletedEscelationsSuccess
    extends GetCompletedEscelationsState {
  final ReturnGoodsResponse returns;

  const GetCompletedEscelationsSuccess(this.returns);

  @override
  List<Object> get props => [returns];
}

final class GetCompletedEscelationsFailure
    extends GetCompletedEscelationsState {
  final ApiFailure failure;
  const GetCompletedEscelationsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
