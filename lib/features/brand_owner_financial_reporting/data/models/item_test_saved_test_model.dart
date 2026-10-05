import '../../domain/entities/item_test_saved_test_entity.dart';
import 'item_test_result_model.dart';

class ItemTestSavedTestModel extends ItemTestSavedTestEntity {
  const ItemTestSavedTestModel({
    required super.id,
    required super.itemName,
    required super.branchName,
    required super.dateTime,
    required super.details,
  });

  factory ItemTestSavedTestModel.fromJson(Map<String, dynamic> json) {
    return ItemTestSavedTestModel(
      id: json['id']?.toString() ?? '',
      itemName: (json['item_name'] ?? json['itemName'])?.toString() ?? '',
      branchName: (json['branch_name'] ?? json['branchName'])?.toString() ?? '',
      dateTime:
          (json['date_time'] ?? json['dateTime'] ?? json['date'] ?? '')
              ?.toString() ??
          '',
      details: ItemTestResultModel(
        id: json['id']?.toString() ?? '',
        profitMargin:
            ((json['profit_margin'] ?? json['profitMargin'] ?? 0) as num)
                .toDouble(),
        profitMarginLabel:
            (json['profit_margin_label'] ?? json['profitMarginLabel'] ?? '')
                .toString(),
        expectedMonthlyProfit:
            ((json['expected_monthly_profit'] ??
                        json['expectedMonthlyProfit'] ??
                        0)
                    as num)
                .toDouble(),
        expectedClassification:
            (json['expected_classification'] ??
                    json['expectedClassification'] ??
                    '')
                .toString(),
        menuImpact: (json['menu_impact'] ?? json['menuImpact'] ?? '')
            .toString(),
        date: (json['date'] ?? '').toString(),
        branchName: (json['branch_name'] ?? json['branchName'] ?? '')
            .toString(),
        itemName: (json['item_name'] ?? json['itemName'] ?? '').toString(),
        expectedSellingPrice:
            ((json['expected_selling_price'] ??
                        json['expectedSellingPrice'] ??
                        0)
                    as num)
                .toDouble(),
        productionCost:
            ((json['production_cost'] ?? json['productionCost'] ?? 0) as num)
                .toDouble(),
        expectedSales:
            ((json['expected_sales'] ?? json['expectedSales'] ?? 0) as num)
                .toInt(),
        expectedGrowth:
            ((json['expected_growth'] ?? json['expectedGrowth'] ?? 0) as num)
                .toDouble(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'item_name': itemName,
    'branch_name': branchName,
    'date_time': dateTime,
    'details': (details as ItemTestResultModel).toJson(),
  };
}
