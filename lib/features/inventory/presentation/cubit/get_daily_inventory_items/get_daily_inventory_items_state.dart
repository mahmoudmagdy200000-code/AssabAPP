import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/inventory/data/models/daily_inventory_items_response.dart';
import 'package:equatable/equatable.dart';

sealed class GetDailyInventoryItemsState extends Equatable {
  const GetDailyInventoryItemsState();

  @override
  List<Object> get props => [];
}

final class GetDailyInventoryItemsInit extends GetDailyInventoryItemsState {
  const GetDailyInventoryItemsInit();
}

final class GetDailyInventoryItemsLoading extends GetDailyInventoryItemsState {
  const GetDailyInventoryItemsLoading();
}

final class GetDailyInventoryItemsSuccess extends GetDailyInventoryItemsState {
  final List<DailyInventoryItem> items;

  const GetDailyInventoryItemsSuccess(this.items);

  @override
  List<Object> get props => [items];
}

final class GetDailyInventoryItemsFailure extends GetDailyInventoryItemsState {
  final ApiFailure failure;

  const GetDailyInventoryItemsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
