import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/return_goods_response.dart';

sealed class GetReturnsState extends Equatable {
  const GetReturnsState();

  @override
  List<Object> get props => [];
}

final class GetReturnsInit extends GetReturnsState {
  const GetReturnsInit();
}

final class GetReturnsLoading extends GetReturnsState {
  const GetReturnsLoading();
}

final class GetReturnsSuccess extends GetReturnsState {
  final ReturnGoodsResponse returns;

  const GetReturnsSuccess(this.returns);

  @override
  List<Object> get props => [returns];
}

final class GetReturnsFailure extends GetReturnsState {
  final ApiFailure failure;
  const GetReturnsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
