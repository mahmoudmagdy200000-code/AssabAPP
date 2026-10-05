import '../../domain/entities/brand_owner_menu_engineering_entity.dart';

class MenuEngineeringOverviewItemModel
    extends MenuEngineeringOverviewItemEntity {
  const MenuEngineeringOverviewItemModel({
    required super.itemsCount,
    required super.percentage,
    required super.isHighProfitability,
  });

  factory MenuEngineeringOverviewItemModel.fromJson(Map<String, dynamic> json) {
    return MenuEngineeringOverviewItemModel(
      itemsCount: json['items_count'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      isHighProfitability: json['is_high_profitability'] as bool? ?? true,
    );
  }
}

class MenuEngineeringCategoryItemModel
    extends MenuEngineeringCategoryItemEntity {
  const MenuEngineeringCategoryItemModel({
    required super.category,
    required super.salesPercentage,
    required super.profitPercentage,
  });

  factory MenuEngineeringCategoryItemModel.fromJson(Map<String, dynamic> json) {
    return MenuEngineeringCategoryItemModel(
      category: json['category']?.toString() ?? '',
      salesPercentage: (json['sales_percentage'] as num?)?.toDouble() ?? 0.0,
      profitPercentage: (json['profit_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class MenuEngineeringCategoryModel extends MenuEngineeringCategoryEntity {
  const MenuEngineeringCategoryModel({
    required super.itemsCount,
    required super.percentage,
    required super.amount,
    required super.amountPercentage,
    required super.items,
  });

  factory MenuEngineeringCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuEngineeringCategoryModel(
      itemsCount: json['items_count'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      amountPercentage: (json['amount_percentage'] as num?)?.toDouble() ?? 0.0,
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => MenuEngineeringCategoryItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class MenuEngineeringModel extends MenuEngineeringEntity {
  const MenuEngineeringModel({
    required super.year,
    required super.month,
    required super.monthName,
    required super.comparedYear,
    required super.comparedMonth,
    required super.comparedMonthName,
    required super.branchId,
    required super.branchName,
    required super.puzzles,
    required super.stars,
    required super.dogs,
    required super.workhorses,
    required super.puzzlesCategory,
    required super.starsCategory,
    required super.dogsCategory,
    required super.workhorsesCategory,
  });

  factory MenuEngineeringModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return MenuEngineeringModel(
      year: data['year'] as int? ?? DateTime.now().year,
      month: data['month'] as int? ?? DateTime.now().month,
      monthName: data['month_name']?.toString() ?? '',
      comparedYear: data['compared_year'] as int? ?? DateTime.now().year,
      comparedMonth: data['compared_month'] as int? ?? DateTime.now().month - 1,
      comparedMonthName: data['compared_month_name']?.toString() ?? '',
      branchId: data['branch_id']?.toString() ?? '',
      branchName: data['branch_name']?.toString() ?? '',
      puzzles: MenuEngineeringOverviewItemModel.fromJson(
        data['puzzles'] as Map<String, dynamic>? ?? {},
      ),
      stars: MenuEngineeringOverviewItemModel.fromJson(
        data['stars'] as Map<String, dynamic>? ?? {},
      ),
      dogs: MenuEngineeringOverviewItemModel.fromJson(
        data['dogs'] as Map<String, dynamic>? ?? {},
      ),
      workhorses: MenuEngineeringOverviewItemModel.fromJson(
        data['workhorses'] as Map<String, dynamic>? ?? {},
      ),
      puzzlesCategory: MenuEngineeringCategoryModel.fromJson(
        data['puzzles_category'] as Map<String, dynamic>? ?? {},
      ),
      starsCategory: MenuEngineeringCategoryModel.fromJson(
        data['stars_category'] as Map<String, dynamic>? ?? {},
      ),
      dogsCategory: MenuEngineeringCategoryModel.fromJson(
        data['dogs_category'] as Map<String, dynamic>? ?? {},
      ),
      workhorsesCategory: MenuEngineeringCategoryModel.fromJson(
        data['workhorses_category'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
