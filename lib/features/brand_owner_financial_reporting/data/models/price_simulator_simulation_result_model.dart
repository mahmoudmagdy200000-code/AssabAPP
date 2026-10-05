import '../../domain/entities/price_simulator_simulation_result_entity.dart';

class PriceSimulatorSimulationResultModel
    extends PriceSimulatorSimulationResultEntity {
  const PriceSimulatorSimulationResultModel({
    required super.newPrice,
    required super.expectedSales,
    required super.expectedSalesChangePercentage,
    required super.newUnitProfit,
    required super.newUnitProfitChangePercentage,
    required super.newMonthlyProfit,
    required super.profitChange,
    required super.profitChangePercentage,
    required super.date,
    required super.branchName,
    required super.itemName,
    required super.currentSellingPrice,
    required super.productionCost,
    required super.currentMonthlySales,
    required super.expectedGrowthPercentage,
  });

  factory PriceSimulatorSimulationResultModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return PriceSimulatorSimulationResultModel(
      newPrice: (data['new_price'] ?? data['newPrice'] ?? 0).toDouble(),
      expectedSales: (data['expected_sales'] ?? data['expectedSales'] ?? 0)
          .toInt(),
      expectedSalesChangePercentage:
          (data['expected_sales_change_percentage'] ??
                  data['expectedSalesChangePercentage'] ??
                  0)
              .toDouble(),
      newUnitProfit: (data['new_unit_profit'] ?? data['newUnitProfit'] ?? 0)
          .toDouble(),
      newUnitProfitChangePercentage:
          (data['new_unit_profit_change_percentage'] ??
                  data['newUnitProfitChangePercentage'] ??
                  0)
              .toDouble(),
      newMonthlyProfit:
          (data['new_monthly_profit'] ?? data['newMonthlyProfit'] ?? 0)
              .toDouble(),
      profitChange: (data['profit_change'] ?? data['profitChange'] ?? 0)
          .toDouble(),
      profitChangePercentage:
          (data['profit_change_percentage'] ??
                  data['profitChangePercentage'] ??
                  0)
              .toDouble(),
      date: (data['date'] ?? data['created_at'] ?? '')?.toString() ?? '',
      branchName: (data['branch_name'] ?? data['branchName'])?.toString() ?? '',
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
    'new_price': newPrice,
    'expected_sales': expectedSales,
    'expected_sales_change_percentage': expectedSalesChangePercentage,
    'new_unit_profit': newUnitProfit,
    'new_unit_profit_change_percentage': newUnitProfitChangePercentage,
    'new_monthly_profit': newMonthlyProfit,
    'profit_change': profitChange,
    'profit_change_percentage': profitChangePercentage,
    'date': date,
    'branch_name': branchName,
    'item_name': itemName,
    'current_selling_price': currentSellingPrice,
    'production_cost': productionCost,
    'current_monthly_sales': currentMonthlySales,
    'expected_growth_percentage': expectedGrowthPercentage,
  };
}
