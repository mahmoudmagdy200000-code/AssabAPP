import 'package:equatable/equatable.dart';

class PriceSimulatorItemInfoEntity extends Equatable {
  final String itemId;
  final String itemName;
  final double currentSellingPrice;
  final double productionCost;
  final int currentMonthlySales;
  final double expectedGrowthPercentage;

  const PriceSimulatorItemInfoEntity({
    required this.itemId,
    required this.itemName,
    required this.currentSellingPrice,
    required this.productionCost,
    required this.currentMonthlySales,
    required this.expectedGrowthPercentage,
  });

  @override
  List<Object> get props => [
    itemId,
    itemName,
    currentSellingPrice,
    productionCost,
    currentMonthlySales,
    expectedGrowthPercentage,
  ];
}
