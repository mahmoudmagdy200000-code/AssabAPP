import '../../domain/entities/item_test_result_entity.dart';

class ItemTestResultModel extends ItemTestResultEntity {
  const ItemTestResultModel({
    required super.id,
    required super.profitMargin,
    required super.profitMarginLabel,
    required super.expectedMonthlyProfit,
    required super.expectedClassification,
    required super.menuImpact,
    required super.date,
    required super.branchName,
    required super.itemName,
    required super.expectedSellingPrice,
    required super.productionCost,
    required super.expectedSales,
    required super.expectedGrowth,
  });

  factory ItemTestResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return ItemTestResultModel(
      id: data['id']?.toString() ?? '',
      profitMargin: (data['profit_margin'] ?? data['profitMargin'] ?? 0)
          .toDouble(),
      profitMarginLabel:
          (data['profit_margin_label'] ?? data['profitMarginLabel'] ?? '')
              .toString(),
      expectedMonthlyProfit:
          (data['expected_monthly_profit'] ??
                  data['expectedMonthlyProfit'] ??
                  0)
              .toDouble(),
      expectedClassification:
          (data['expected_classification'] ??
                  data['expectedClassification'] ??
                  '')
              .toString(),
      menuImpact: (data['menu_impact'] ?? data['menuImpact'] ?? '').toString(),
      date: (data['date'] ?? '').toString(),
      branchName: (data['branch_name'] ?? data['branchName'] ?? '').toString(),
      itemName: (data['item_name'] ?? data['itemName'] ?? '').toString(),
      expectedSellingPrice:
          (data['expected_selling_price'] ?? data['expectedSellingPrice'] ?? 0)
              .toDouble(),
      productionCost: (data['production_cost'] ?? data['productionCost'] ?? 0)
          .toDouble(),
      expectedSales: (data['expected_sales'] ?? data['expectedSales'] ?? 0)
          .toInt(),
      expectedGrowth: (data['expected_growth'] ?? data['expectedGrowth'] ?? 0)
          .toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'profit_margin': profitMargin,
    'profit_margin_label': profitMarginLabel,
    'expected_monthly_profit': expectedMonthlyProfit,
    'expected_classification': expectedClassification,
    'menu_impact': menuImpact,
    'date': date,
    'branch_name': branchName,
    'item_name': itemName,
    'expected_selling_price': expectedSellingPrice,
    'production_cost': productionCost,
    'expected_sales': expectedSales,
    'expected_growth': expectedGrowth,
  };
}
