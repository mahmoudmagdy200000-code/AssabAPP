import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/daily_inventory_list_response.dart';
import '../../../data/models/monthly_inventory_list_response.dart';
import '../../../data/models/wasted_damage_list_response.dart';

sealed class GetInventoryRequestsState extends Equatable {
  const GetInventoryRequestsState();

  @override
  List<Object> get props => [];
}

final class GetInventoryRequestsInit extends GetInventoryRequestsState {
  const GetInventoryRequestsInit();
}

final class GetInventoryRequestsLoading extends GetInventoryRequestsState {
  const GetInventoryRequestsLoading();
}

final class GetDailyInventoryRequestsSuccess extends GetInventoryRequestsState {
  final List<DailyInventoryListResponseSession> response;

  const GetDailyInventoryRequestsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetWasteDamageInventoryRequestsSuccess
    extends GetInventoryRequestsState {
  final List<WastedDamageListEntry> response;

  const GetWasteDamageInventoryRequestsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetMonthlyInventoryRequestsSuccess
    extends GetInventoryRequestsState {
  final List<MonthlyInventoryListItem> products;

  const GetMonthlyInventoryRequestsSuccess(this.products);

  bool get isMonthlyInventoryExistSession => products.isNotEmpty;

  String get monthlyInventoryExistSessionId => products.first.id;

  @override
  List<Object> get props => [products];
}

final class GetInventoryRequestsFailure extends GetInventoryRequestsState {
  final ApiFailure failure;

  const GetInventoryRequestsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
