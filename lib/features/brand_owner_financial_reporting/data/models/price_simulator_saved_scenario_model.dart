import '../../domain/entities/price_simulator_saved_scenario_entity.dart';
import 'price_simulator_simulation_result_model.dart';

class PriceSimulatorSavedScenarioModel
    extends PriceSimulatorSavedScenarioEntity {
  const PriceSimulatorSavedScenarioModel({
    required super.id,
    required super.itemName,
    required super.newPrice,
    required super.dateTime,
    required super.details,
  });

  factory PriceSimulatorSavedScenarioModel.fromJson(Map<String, dynamic> json) {
    final details = json['details'] as Map<String, dynamic>? ?? {};

    return PriceSimulatorSavedScenarioModel(
      id: json['id']?.toString() ?? '',
      itemName: (details['item_name'] ?? details['itemName'] ?? '').toString(),
      newPrice: ((details['new_price'] ?? details['newPrice'] ?? 0) as num)
          .toDouble(),
      dateTime:
          (details['date_time'] ?? details['dateTime'] ?? details['date'] ?? '')
              .toString(),
      details: PriceSimulatorSimulationResultModel(
        newPrice: ((details['new_price'] ?? details['newPrice'] ?? 0) as num)
            .toDouble(),
        expectedSales:
            ((details['expected_sales'] ?? details['expectedSales'] ?? 0)
                    as num)
                .toInt(),
        expectedSalesChangePercentage:
            ((details['expected_sales_change_percentage'] ??
                        details['expectedSalesChangePercentage'] ??
                        0)
                    as num)
                .toDouble(),
        newUnitProfit:
            ((details['new_unit_profit'] ?? details['newUnitProfit'] ?? 0)
                    as num)
                .toDouble(),
        newUnitProfitChangePercentage:
            ((details['new_unit_profit_change_percentage'] ??
                        details['newUnitProfitChangePercentage'] ??
                        0)
                    as num)
                .toDouble(),
        newMonthlyProfit:
            ((details['new_monthly_profit'] ?? details['newMonthlyProfit'] ?? 0)
                    as num)
                .toDouble(),
        profitChange:
            ((details['profit_change'] ?? details['profitChange'] ?? 0) as num)
                .toDouble(),
        profitChangePercentage:
            ((details['profit_change_percentage'] ??
                        details['profitChangePercentage'] ??
                        0)
                    as num)
                .toDouble(),
        date: (details['date'] ?? details['created_at'] ?? '').toString(),
        branchName: (details['branch_name'] ?? details['branchName'] ?? '')
            .toString(),
        itemName: (details['item_name'] ?? details['itemName'] ?? '')
            .toString(),
        currentSellingPrice:
            ((details['current_selling_price'] ??
                        details['currentSellingPrice'] ??
                        0)
                    as num)
                .toDouble(),
        productionCost:
            ((details['production_cost'] ?? details['productionCost'] ?? 0)
                    as num)
                .toDouble(),
        currentMonthlySales:
            ((details['current_monthly_sales'] ??
                        details['currentMonthlySales'] ??
                        0)
                    as num)
                .toInt(),
        expectedGrowthPercentage:
            ((details['expected_growth_percentage'] ??
                        details['expectedGrowthPercentage'] ??
                        0)
                    as num)
                .toDouble(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'item_name': itemName,
    'new_price': newPrice,
    'date_time': dateTime,
    'details': (details as PriceSimulatorSimulationResultModel).toJson(),
  };
}
