import 'package:equatable/equatable.dart';

class ProfitAndLossSummaryEntity extends Equatable {
  final double totalRevenue;
  final double totalExpenses;
  final double netProfit;
  final double profitMarginPercentage;
  final bool isProfit;

  const ProfitAndLossSummaryEntity({
    required this.totalRevenue,
    required this.totalExpenses,
    required this.netProfit,
    required this.profitMarginPercentage,
    required this.isProfit,
  });

  @override
  List<Object> get props => [
    totalRevenue,
    totalExpenses,
    netProfit,
    profitMarginPercentage,
    isProfit,
  ];
}

class ProfitAndLossChartEntity extends Equatable {
  final double turnoverTotal;
  final double directCostTotal;
  final double grossProfit;
  final double grandTotalCost;
  final double profitabilityAmount;
  final double gAndAExpenses;
  final double otherIncomeExpenses;
  final double netProfitAndLoss;

  const ProfitAndLossChartEntity({
    required this.turnoverTotal,
    required this.directCostTotal,
    required this.grossProfit,
    required this.grandTotalCost,
    required this.profitabilityAmount,
    required this.gAndAExpenses,
    required this.otherIncomeExpenses,
    required this.netProfitAndLoss,
  });

  @override
  List<Object> get props => [
    turnoverTotal,
    directCostTotal,
    grossProfit,
    grandTotalCost,
    profitabilityAmount,
    gAndAExpenses,
    otherIncomeExpenses,
    netProfitAndLoss,
  ];
}

class ProfitAndLossStatementEntity extends Equatable {
  final int year;
  final int month;
  final String branchId;
  final String branchName;
  final ProfitAndLossSummaryEntity summary;
  final ProfitAndLossChartEntity chart;

  const ProfitAndLossStatementEntity({
    required this.year,
    required this.month,
    required this.branchId,
    required this.branchName,
    required this.summary,
    required this.chart,
  });

  @override
  List<Object> get props => [year, month, branchId, branchName, summary, chart];
}
