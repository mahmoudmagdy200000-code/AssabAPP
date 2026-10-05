import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/wasted_damage_items_response.dart';

sealed class GetWastedDamageItemsState extends Equatable {
  const GetWastedDamageItemsState();

  @override
  List<Object> get props => [];
}

final class GetWastedDamageItemsInit extends GetWastedDamageItemsState {
  const GetWastedDamageItemsInit();
}

final class GetWastedDamageItemsLoading extends GetWastedDamageItemsState {
  const GetWastedDamageItemsLoading();
}

final class GetWastedDamageItemsSuccess extends GetWastedDamageItemsState {
  final WastedDamageItemsResponse response;

  const GetWastedDamageItemsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetWastedDamageItemsFailure extends GetWastedDamageItemsState {
  final ApiFailure failure;

  const GetWastedDamageItemsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
