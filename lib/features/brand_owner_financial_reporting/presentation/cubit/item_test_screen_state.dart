import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/item_test_result_entity.dart';

sealed class ItemTestScreenState extends Equatable {
  const ItemTestScreenState();

  @override
  List<Object> get props => [];
}

final class ItemTestScreenInit extends ItemTestScreenState {
  const ItemTestScreenInit();
}

final class ItemTestScreenFormReady extends ItemTestScreenState {
  final String itemName;
  final double expectedSellingPrice;
  final double productionCost;
  final int expectedSales;
  final double expectedGrowth;

  const ItemTestScreenFormReady({
    this.itemName = '',
    this.expectedSellingPrice = 0,
    this.productionCost = 0,
    this.expectedSales = 0,
    this.expectedGrowth = 0,
  });

  @override
  List<Object> get props => [
    itemName,
    expectedSellingPrice,
    productionCost,
    expectedSales,
    expectedGrowth,
  ];
}

final class ItemTestScreenSubmitting extends ItemTestScreenState {
  const ItemTestScreenSubmitting();
}

final class ItemTestScreenSubmitSuccess extends ItemTestScreenState {
  final ItemTestResultEntity result;

  const ItemTestScreenSubmitSuccess(this.result);

  @override
  List<Object> get props => [result];
}

final class ItemTestScreenSubmitFailure extends ItemTestScreenState {
  final ApiFailure failure;

  const ItemTestScreenSubmitFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
