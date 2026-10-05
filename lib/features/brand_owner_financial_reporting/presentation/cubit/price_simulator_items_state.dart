import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/price_simulator_item_entity.dart';

sealed class PriceSimulatorItemsState extends Equatable {
  const PriceSimulatorItemsState();

  @override
  List<Object> get props => [];
}

final class PriceSimulatorItemsInit extends PriceSimulatorItemsState {
  const PriceSimulatorItemsInit();
}

final class PriceSimulatorItemsLoading extends PriceSimulatorItemsState {
  const PriceSimulatorItemsLoading();
}

final class PriceSimulatorItemsSuccess extends PriceSimulatorItemsState {
  final List<PriceSimulatorItemEntity> items;
  final List<PriceSimulatorItemEntity> filteredItems;
  final String searchQuery;

  const PriceSimulatorItemsSuccess({
    required this.items,
    required this.filteredItems,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [items, filteredItems, searchQuery];
}

final class PriceSimulatorItemsFailure extends PriceSimulatorItemsState {
  final ApiFailure failure;

  const PriceSimulatorItemsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
