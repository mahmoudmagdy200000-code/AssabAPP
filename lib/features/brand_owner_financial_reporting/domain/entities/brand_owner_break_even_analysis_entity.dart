import 'package:equatable/equatable.dart';

class BreakEvenAnalysisMetricsEntity extends Equatable {
  final double currentPointX;
  final double currentPointY;
  final double fixedCostX;
  final double fixedCostY;

  const BreakEvenAnalysisMetricsEntity({
    required this.currentPointX,
    required this.currentPointY,
    required this.fixedCostX,
    required this.fixedCostY,
  });

  @override
  List<Object> get props => [
    currentPointX,
    currentPointY,
    fixedCostX,
    fixedCostY,
  ];
}

class BreakEvenAnalysisFixedCostsEntity extends Equatable {
  final double rentAndUtilities;
  final double salaries;
  final double insuranceAndLicenses;
  final double totalFixed;

  const BreakEvenAnalysisFixedCostsEntity({
    required this.rentAndUtilities,
    required this.salaries,
    required this.insuranceAndLicenses,
    required this.totalFixed,
  });

  @override
  List<Object> get props => [rentAndUtilities, salaries, insuranceAndLicenses, totalFixed];
}

class BreakEvenAnalysisContributionMarginEntity extends Equatable {
  final double grossProfitMargin;
  final double variableCosts;

  const BreakEvenAnalysisContributionMarginEntity({
    required this.grossProfitMargin,
    required this.variableCosts,
  });

  @override
  List<Object> get props => [grossProfitMargin, variableCosts];
}

class BreakEvenAnalysisFormulaEntity extends Equatable {
  final double fixedCosts;
  final double contributionMargin;
  final double result;

  const BreakEvenAnalysisFormulaEntity({
    required this.fixedCosts,
    required this.contributionMargin,
    required this.result,
  });

  @override
  List<Object> get props => [fixedCosts, contributionMargin, result];
}

class BreakEvenAnalysisEntity extends Equatable {
  final int year;
  final int month;
  final String monthName;
  final String previousMonthName;
  final String branchId;
  final String branchName;
  final String status;
  final double currentPointPosition;
  final BreakEvenAnalysisMetricsEntity metrics;
  final BreakEvenAnalysisFixedCostsEntity fixedCosts;
  final BreakEvenAnalysisContributionMarginEntity contributionMargin;
  final BreakEvenAnalysisFormulaEntity formula;

  const BreakEvenAnalysisEntity({
    required this.year,
    required this.month,
    required this.monthName,
    required this.previousMonthName,
    required this.branchId,
    required this.branchName,
    required this.status,
    required this.currentPointPosition,
    required this.metrics,
    required this.fixedCosts,
    required this.contributionMargin,
    required this.formula,
  });

  @override
  List<Object> get props => [
    year,
    month,
    monthName,
    previousMonthName,
    branchId,
    branchName,
    status,
    currentPointPosition,
    metrics,
    fixedCosts,
    contributionMargin,
    formula,
  ];
}
