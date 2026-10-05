import 'package:equatable/equatable.dart';

import '../enums/brand_owner_smart_compare_type_enum.dart';

class SmartComparisonSummaryEntity extends Equatable {
  final double totalSales;
  final double totalProfitability;
  final double totalProfitabilityPercentage;
  final double netProfitPercentage;
  final double profitMarginPercentage;

  const SmartComparisonSummaryEntity({
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

class SmartComparisonChartDataEntity extends Equatable {
  final int mainMonth;
  final int mainYear;
  final double mainValue;
  final int comparedMonth;
  final int comparedYear;
  final double comparedValue;

  const SmartComparisonChartDataEntity({
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

class SmartComparisonEntity extends Equatable {
  final int year;
  final int month;
  final int comparedYear;
  final int comparedMonth;
  final String monthName;
  final String comparedMonthName;
  final BrandOwnerSmartCompareTypeEnum type;
  final String branchId;
  final String branchName;
  final String? comparedBranchId;
  final String? comparedBranchName;
  final SmartComparisonSummaryEntity summary;
  final SmartComparisonChartDataEntity chartData;

  const SmartComparisonEntity({
    required this.year,
    required this.month,
    required this.comparedYear,
    required this.comparedMonth,
    required this.monthName,
    required this.comparedMonthName,
    required this.type,
    required this.branchId,
    required this.branchName,
    this.comparedBranchId,
    this.comparedBranchName,
    required this.summary,
    required this.chartData,
  });

  @override
  List<Object?> get props => [
    year,
    month,
    comparedYear,
    comparedMonth,
    monthName,
    comparedMonthName,
    type,
    branchId,
    branchName,
    comparedBranchId,
    comparedBranchName,
    summary,
    chartData,
  ];
}
