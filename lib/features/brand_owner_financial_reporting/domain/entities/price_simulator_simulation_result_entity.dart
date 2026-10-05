import 'package:equatable/equatable.dart';

class PriceSimulatorSimulationResultEntity extends Equatable {
  final double newPrice;
  final int expectedSales;
  final double expectedSalesChangePercentage;
  final double newUnitProfit;
  final double newUnitProfitChangePercentage;
  final double newMonthlyProfit;
  final double profitChange;
  final double profitChangePercentage;
  final String date;
  final String branchName;
  final String itemName;
  final double currentSellingPrice;
  final double productionCost;
  final int currentMonthlySales;
  final double expectedGrowthPercentage;

  const PriceSimulatorSimulationResultEntity({
    required this.newPrice,
    required this.expectedSales,
    required this.expectedSalesChangePercentage,
    required this.newUnitProfit,
    required this.newUnitProfitChangePercentage,
    required this.newMonthlyProfit,
    required this.profitChange,
    required this.profitChangePercentage,
    required this.date,
    required this.branchName,
    required this.itemName,
    required this.currentSellingPrice,
    required this.productionCost,
    required this.currentMonthlySales,
    required this.expectedGrowthPercentage,
  });

  @override
  List<Object> get props => [
    newPrice,
    expectedSales,
    expectedSalesChangePercentage,
    newUnitProfit,
    newUnitProfitChangePercentage,
    newMonthlyProfit,
    profitChange,
    profitChangePercentage,
    date,
    branchName,
    itemName,
    currentSellingPrice,
    productionCost,
    currentMonthlySales,
    expectedGrowthPercentage,
  ];
}
