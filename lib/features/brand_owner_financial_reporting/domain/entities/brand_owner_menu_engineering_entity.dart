import 'package:equatable/equatable.dart';

class MenuEngineeringOverviewItemEntity extends Equatable {
  final int itemsCount;
  final double percentage;
  final bool isHighProfitability;

  const MenuEngineeringOverviewItemEntity({
    required this.itemsCount,
    required this.percentage,
    required this.isHighProfitability,
  });

  @override
  List<Object> get props => [itemsCount, percentage, isHighProfitability];
}

class MenuEngineeringCategoryItemEntity extends Equatable {
  final String category;
  final double salesPercentage;
  final double profitPercentage;

  const MenuEngineeringCategoryItemEntity({
    required this.category,
    required this.salesPercentage,
    required this.profitPercentage,
  });

  @override
  List<Object> get props => [category, salesPercentage, profitPercentage];
}

class MenuEngineeringCategoryEntity extends Equatable {
  final int itemsCount;
  final double percentage;
  final double amount;
  final double amountPercentage;
  final List<MenuEngineeringCategoryItemEntity> items;

  const MenuEngineeringCategoryEntity({
    required this.itemsCount,
    required this.percentage,
    required this.amount,
    required this.amountPercentage,
    required this.items,
  });

  @override
  List<Object> get props => [
    itemsCount,
    percentage,
    amount,
    amountPercentage,
    items,
  ];
}

class MenuEngineeringEntity extends Equatable {
  final int year;
  final int month;
  final String monthName;
  final int comparedYear;
  final int comparedMonth;
  final String comparedMonthName;
  final String branchId;
  final String branchName;
  final MenuEngineeringOverviewItemEntity puzzles;
  final MenuEngineeringOverviewItemEntity stars;
  final MenuEngineeringOverviewItemEntity dogs;
  final MenuEngineeringOverviewItemEntity workhorses;
  final MenuEngineeringCategoryEntity puzzlesCategory;
  final MenuEngineeringCategoryEntity starsCategory;
  final MenuEngineeringCategoryEntity dogsCategory;
  final MenuEngineeringCategoryEntity workhorsesCategory;

  const MenuEngineeringEntity({
    required this.year,
    required this.month,
    required this.monthName,
    required this.comparedYear,
    required this.comparedMonth,
    required this.comparedMonthName,
    required this.branchId,
    required this.branchName,
    required this.puzzles,
    required this.stars,
    required this.dogs,
    required this.workhorses,
    required this.puzzlesCategory,
    required this.starsCategory,
    required this.dogsCategory,
    required this.workhorsesCategory,
  });

  @override
  List<Object> get props => [
    year,
    month,
    monthName,
    comparedYear,
    comparedMonth,
    comparedMonthName,
    branchId,
    branchName,
    puzzles,
    stars,
    dogs,
    workhorses,
    puzzlesCategory,
    starsCategory,
    dogsCategory,
    workhorsesCategory,
  ];
}
