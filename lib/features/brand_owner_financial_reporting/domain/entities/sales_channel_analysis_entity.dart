import 'package:equatable/equatable.dart';

class SalesChannelAnalysisSummaryEntity extends Equatable {
  final double totalSales;
  final double totalProfitability;
  final double totalProfitabilityPercentage;
  final double netProfitPercentage;
  final double profitMarginPercentage;

  const SalesChannelAnalysisSummaryEntity({
    required this.totalSales,
    required this.totalProfitability,
    required this.totalProfitabilityPercentage,
    required this.netProfitPercentage,
    required this.profitMarginPercentage,
  });

  @override
  List<Object> get props => [
    totalSales,
    totalProfitability,
    totalProfitabilityPercentage,
    netProfitPercentage,
    profitMarginPercentage,
  ];
}

class SalesChannelAnalysisChartDataEntity extends Equatable {
  final int mainMonth;
  final int mainYear;
  final double mainValue;
  final int comparedMonth;
  final int comparedYear;
  final double comparedValue;

  const SalesChannelAnalysisChartDataEntity({
    required this.mainMonth,
    required this.mainYear,
    required this.mainValue,
    required this.comparedMonth,
    required this.comparedYear,
    required this.comparedValue,
  });

  @override
  List<Object> get props => [
    mainMonth,
    mainYear,
    mainValue,
    comparedMonth,
    comparedYear,
    comparedValue,
  ];
}

class SalesChannelAnalysisEntity extends Equatable {
  final int year;
  final int month;
  final int comparedYear;
  final int comparedMonth;
  final String monthName;
  final String branchId;
  final String branchName;
  final SalesChannelAnalysisSummaryEntity summary;
  final SalesChannelAnalysisChartDataEntity chartData;

  const SalesChannelAnalysisEntity({
    required this.year,
    required this.month,
    required this.comparedYear,
    required this.comparedMonth,
    required this.monthName,
    required this.branchId,
    required this.branchName,
    required this.summary,
    required this.chartData,
  });

  @override
  List<Object> get props => [
    year,
    month,
    comparedYear,
    comparedMonth,
    monthName,
    branchId,
    branchName,
    summary,
    chartData,
  ];
}
