import '../../domain/entities/price_simulator_item_info_entity.dart';

class PriceSimulatorItemInfoModel extends PriceSimulatorItemInfoEntity {
  const PriceSimulatorItemInfoModel({
    required super.itemId,
    required super.itemName,
    required super.currentSellingPrice,
    required super.productionCost,
    required super.currentMonthlySales,
    required super.expectedGrowthPercentage,
  });

  factory PriceSimulatorItemInfoModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return PriceSimulatorItemInfoModel(
      itemId: data['item_id']?.toString() ?? '',
      itemName: (data['item_name'] ?? data['itemName'])?.toString() ?? '',
      currentSellingPrice:
          (data['current_selling_price'] ?? data['currentSellingPrice'] ?? 0)
              .toDouble(),
      productionCost: (data['production_cost'] ?? data['productionCost'] ?? 0)
          .toDouble(),
      currentMonthlySales:
          (data['current_monthly_sales'] ?? data['currentMonthlySales'] ?? 0)
              .toInt(),
      expectedGrowthPercentage:
          (data['expected_growth_percentage'] ??
                  data['expectedGrowthPercentage'] ??
                  0)
              .toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'item_id': itemId,
    'item_name': itemName,
    'current_selling_price': currentSellingPrice,
    'production_cost': productionCost,
    'current_monthly_sales': currentMonthlySales,
    'expected_growth_percentage': expectedGrowthPercentage,
  };
}
