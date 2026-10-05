import 'package:equatable/equatable.dart';

class SalesChannelLevel2ChartDataEntity extends Equatable {
  final DateTime month;
  final double value;

  const SalesChannelLevel2ChartDataEntity({
    required this.month,
    required this.value,
  });

  @override
  List<Object> get props => [month, value];
}

class SalesChannelLevel2ItemEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final double salesAmount;
  final double percentageChange;
  final bool isPositive;
  final String comparisonText;
  final double commissionAmount;
  final double commissionPercentage;
  final double profitabilityAmount;
  final double profitabilityPercentage;
  final int orderCount;
  final double averageOrderValue;

  const SalesChannelLevel2ItemEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.salesAmount,
    required this.percentageChange,
    required this.isPositive,
    required this.comparisonText,
    required this.commissionAmount,
    required this.commissionPercentage,
    required this.profitabilityAmount,
    required this.profitabilityPercentage,
    required this.orderCount,
    required this.averageOrderValue,
  });

  @override
  List<Object> get props => [
    id,
    name,
    image,
    salesAmount,
    percentageChange,
    isPositive,
    comparisonText,
    commissionAmount,
    commissionPercentage,
    profitabilityAmount,
    profitabilityPercentage,
    orderCount,
    averageOrderValue,
  ];
}

class SalesChannelLevel2Entity extends Equatable {
  final int year;
  final int month;
  final int comparedYear;
  final int comparedMonth;
  final String monthName;
  final int totalCount;
  final List<SalesChannelLevel2ItemEntity> items;
  final List<SalesChannelLevel2ChartDataEntity> chartData;

  const SalesChannelLevel2Entity({
    required this.year,
    required this.month,
    required this.comparedYear,
    required this.comparedMonth,
    required this.monthName,
    required this.totalCount,
    required this.items,
    required this.chartData,
  });

  @override
  List<Object> get props => [
    year,
    month,
    comparedYear,
    comparedMonth,
    monthName,
    totalCount,
    items,
    chartData,
  ];
}
