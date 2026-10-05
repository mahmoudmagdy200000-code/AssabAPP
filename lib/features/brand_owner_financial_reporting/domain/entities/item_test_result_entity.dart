import 'package:equatable/equatable.dart';

class ItemTestResultEntity extends Equatable {
  final String id;
  final double profitMargin;
  final String profitMarginLabel;
  final double expectedMonthlyProfit;
  final String expectedClassification;
  final String menuImpact;
  final String date;
  final String branchName;
  final String itemName;
  final double expectedSellingPrice;
  final double productionCost;
  final int expectedSales;
  final double expectedGrowth;

  const ItemTestResultEntity({
    required this.id,
    required this.profitMargin,
    required this.profitMarginLabel,
    required this.expectedMonthlyProfit,
    required this.expectedClassification,
    required this.menuImpact,
    required this.date,
    required this.branchName,
    required this.itemName,
    required this.expectedSellingPrice,
    required this.productionCost,
    required this.expectedSales,
    required this.expectedGrowth,
  });

  @override
  List<Object> get props => [
    id,
    profitMargin,
    profitMarginLabel,
    expectedMonthlyProfit,
    expectedClassification,
    menuImpact,
    date,
    branchName,
    itemName,
    expectedSellingPrice,
    productionCost,
    expectedSales,
    expectedGrowth,
  ];
}
