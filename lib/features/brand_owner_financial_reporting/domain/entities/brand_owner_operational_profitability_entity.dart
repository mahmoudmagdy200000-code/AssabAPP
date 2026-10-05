import 'package:equatable/equatable.dart';

class OperationalProfitabilityMetricsEntity extends Equatable {
  final String overallPerformance;
  final String overallScore;
  final int starsCount;

  const OperationalProfitabilityMetricsEntity({
    required this.overallPerformance,
    required this.overallScore,
    required this.starsCount,
  });

  @override
  List<Object> get props => [overallPerformance, overallScore, starsCount];
}

class OperationalProfitabilityCoreIndicatorsEntity extends Equatable {
  final double operatingProfit;
  final double operatingProfitChange;
  final bool operatingProfitIsPositive;
  final double ebitda;
  final double ebitdaChange;
  final bool ebitdaIsPositive;
  final double grossProfitMargin;
  final double grossProfitMarginChange;
  final bool grossProfitMarginIsPositive;
  final double returnOnSales;
  final String returnOnSalesLabel;

  const OperationalProfitabilityCoreIndicatorsEntity({
    required this.operatingProfit,
    required this.operatingProfitChange,
    required this.operatingProfitIsPositive,
    required this.ebitda,
    required this.ebitdaChange,
    required this.ebitdaIsPositive,
    required this.grossProfitMargin,
    required this.grossProfitMarginChange,
    required this.grossProfitMarginIsPositive,
    required this.returnOnSales,
    required this.returnOnSalesLabel,
  });

  @override
  List<Object> get props => [
    operatingProfit,
    operatingProfitChange,
    operatingProfitIsPositive,
    ebitda,
    ebitdaChange,
    ebitdaIsPositive,
    grossProfitMargin,
    grossProfitMarginChange,
    grossProfitMarginIsPositive,
    returnOnSales,
    returnOnSalesLabel,
  ];
}

class OperationalProfitabilityEfficiencyEntity extends Equatable {
  final double productivityPerEmployee;
  final double productivityPerEmployeeChange;
  final bool productivityIsPositive;
  final double laborCost;
  final String laborCostLabel;
  final double inventoryTurnover;
  final String inventoryTurnoverUnit;
  final double averageTransactionValue;
  final double spaceEfficiency;
  final String spaceEfficiencyUnit;

  const OperationalProfitabilityEfficiencyEntity({
    required this.productivityPerEmployee,
    required this.productivityPerEmployeeChange,
    required this.productivityIsPositive,
    required this.laborCost,
    required this.laborCostLabel,
    required this.inventoryTurnover,
    required this.inventoryTurnoverUnit,
    required this.averageTransactionValue,
    required this.spaceEfficiency,
    required this.spaceEfficiencyUnit,
  });

  @override
  List<Object> get props => [
    productivityPerEmployee,
    productivityPerEmployeeChange,
    productivityIsPositive,
    laborCost,
    laborCostLabel,
    inventoryTurnover,
    inventoryTurnoverUnit,
    averageTransactionValue,
    spaceEfficiency,
    spaceEfficiencyUnit,
  ];
}

class OperationalProfitabilityBenchmarkEntity extends Equatable {
  final double profitMarginYourRestaurant;
  final double profitMarginIndustry;
  final double laborCostYourRestaurant;
  final double laborCostIndustry;
  final double inventoryTurnoverYourRestaurant;
  final double inventoryTurnoverIndustry;

  const OperationalProfitabilityBenchmarkEntity({
    required this.profitMarginYourRestaurant,
    required this.profitMarginIndustry,
    required this.laborCostYourRestaurant,
    required this.laborCostIndustry,
    required this.inventoryTurnoverYourRestaurant,
    required this.inventoryTurnoverIndustry,
  });

  @override
  List<Object> get props => [
    profitMarginYourRestaurant,
    profitMarginIndustry,
    laborCostYourRestaurant,
    laborCostIndustry,
    inventoryTurnoverYourRestaurant,
    inventoryTurnoverIndustry,
  ];
}

class OperationalProfitabilityEntity extends Equatable {
  final OperationalProfitabilityMetricsEntity metrics;
  final OperationalProfitabilityCoreIndicatorsEntity coreIndicators;
  final OperationalProfitabilityEfficiencyEntity efficiency;
  final OperationalProfitabilityBenchmarkEntity benchmark;

  const OperationalProfitabilityEntity({
    required this.metrics,
    required this.coreIndicators,
    required this.efficiency,
    required this.benchmark,
  });

  @override
  List<Object> get props => [metrics, coreIndicators, efficiency, benchmark];
}
