import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/return_goods_details_response.dart';

sealed class GetReturnDetailsState extends Equatable {
  const GetReturnDetailsState();

  @override
  List<Object> get props => [];
}

final class GetReturnDetailsInit extends GetReturnDetailsState {
  const GetReturnDetailsInit();
}

final class GetReturnDetailsLoading extends GetReturnDetailsState {
  const GetReturnDetailsLoading();
}

final class GetReturnDetailsSuccess extends GetReturnDetailsState {
  final ReturnGoodsDetailsResponse returnDetails;

  const GetReturnDetailsSuccess(this.returnDetails);

  @override
  List<Object> get props => [returnDetails];
}

final class GetReturnDetailsFailure extends GetReturnDetailsState {
  final ApiFailure failure;

  const GetReturnDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
