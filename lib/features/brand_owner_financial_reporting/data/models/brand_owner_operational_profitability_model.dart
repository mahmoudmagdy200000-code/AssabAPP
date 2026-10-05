import '../../domain/entities/brand_owner_operational_profitability_entity.dart';

class OperationalProfitabilityMetricsModel
    extends OperationalProfitabilityMetricsEntity {
  const OperationalProfitabilityMetricsModel({
    required super.overallPerformance,
    required super.overallScore,
    required super.starsCount,
  });

  factory OperationalProfitabilityMetricsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OperationalProfitabilityMetricsModel(
      overallPerformance: json['overall_performance']?.toString() ?? '',
      overallScore: json['overall_score']?.toString() ?? '',
      starsCount: json['stars_count'] as int? ?? 0,
    );
  }
}

class OperationalProfitabilityCoreIndicatorsModel
    extends OperationalProfitabilityCoreIndicatorsEntity {
  const OperationalProfitabilityCoreIndicatorsModel({
    required super.operatingProfit,
    required super.operatingProfitChange,
    required super.operatingProfitIsPositive,
    required super.ebitda,
    required super.ebitdaChange,
    required super.ebitdaIsPositive,
    required super.grossProfitMargin,
    required super.grossProfitMarginChange,
    required super.grossProfitMarginIsPositive,
    required super.returnOnSales,
    required super.returnOnSalesLabel,
  });

  factory OperationalProfitabilityCoreIndicatorsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OperationalProfitabilityCoreIndicatorsModel(
      operatingProfit: (json['operating_profit'] as num?)?.toDouble() ?? 0.0,
      operatingProfitChange:
          (json['operating_profit_change'] as num?)?.toDouble() ?? 0.0,
      operatingProfitIsPositive:
          json['operating_profit_is_positive'] as bool? ?? true,
      ebitda: (json['ebitda'] as num?)?.toDouble() ?? 0.0,
      ebitdaChange: (json['ebitda_change'] as num?)?.toDouble() ?? 0.0,
      ebitdaIsPositive: json['ebitda_is_positive'] as bool? ?? true,
      grossProfitMargin:
          (json['gross_profit_margin'] as num?)?.toDouble() ?? 0.0,
      grossProfitMarginChange:
          (json['gross_profit_margin_change'] as num?)?.toDouble() ?? 0.0,
      grossProfitMarginIsPositive:
          json['gross_profit_margin_is_positive'] as bool? ?? true,
      returnOnSales: (json['return_on_sales'] as num?)?.toDouble() ?? 0.0,
      returnOnSalesLabel: json['return_on_sales_label']?.toString() ?? '',
    );
  }
}

class OperationalProfitabilityEfficiencyModel
    extends OperationalProfitabilityEfficiencyEntity {
  const OperationalProfitabilityEfficiencyModel({
    required super.productivityPerEmployee,
    required super.productivityPerEmployeeChange,
    required super.productivityIsPositive,
    required super.laborCost,
    required super.laborCostLabel,
    required super.inventoryTurnover,
    required super.inventoryTurnoverUnit,
    required super.averageTransactionValue,
    required super.spaceEfficiency,
    required super.spaceEfficiencyUnit,
  });

  factory OperationalProfitabilityEfficiencyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OperationalProfitabilityEfficiencyModel(
      productivityPerEmployee:
          (json['productivity_per_employee'] as num?)?.toDouble() ?? 0.0,
      productivityPerEmployeeChange:
          (json['productivity_per_employee_change'] as num?)?.toDouble() ?? 0.0,
      productivityIsPositive: json['productivity_is_positive'] as bool? ?? true,
      laborCost: (json['labor_cost'] as num?)?.toDouble() ?? 0.0,
      laborCostLabel: json['labor_cost_label']?.toString() ?? '',
      inventoryTurnover:
          (json['inventory_turnover'] as num?)?.toDouble() ?? 0.0,
      inventoryTurnoverUnit: json['inventory_turnover_unit']?.toString() ?? '',
      averageTransactionValue:
          (json['average_transaction_value'] as num?)?.toDouble() ?? 0.0,
      spaceEfficiency: (json['space_efficiency'] as num?)?.toDouble() ?? 0.0,
      spaceEfficiencyUnit: json['space_efficiency_unit']?.toString() ?? '',
    );
  }
}

class OperationalProfitabilityBenchmarkModel
    extends OperationalProfitabilityBenchmarkEntity {
  const OperationalProfitabilityBenchmarkModel({
    required super.profitMarginYourRestaurant,
    required super.profitMarginIndustry,
    required super.laborCostYourRestaurant,
    required super.laborCostIndustry,
    required super.inventoryTurnoverYourRestaurant,
    required super.inventoryTurnoverIndustry,
  });

  factory OperationalProfitabilityBenchmarkModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OperationalProfitabilityBenchmarkModel(
      profitMarginYourRestaurant:
          (json['profit_margin_your_restaurant'] as num?)?.toDouble() ?? 0.0,
      profitMarginIndustry:
          (json['profit_margin_industry'] as num?)?.toDouble() ?? 0.0,
      laborCostYourRestaurant:
          (json['labor_cost_your_restaurant'] as num?)?.toDouble() ?? 0.0,
      laborCostIndustry:
          (json['labor_cost_industry'] as num?)?.toDouble() ?? 0.0,
      inventoryTurnoverYourRestaurant:
          (json['inventory_turnover_your_restaurant'] as num?)?.toDouble() ??
          0.0,
      inventoryTurnoverIndustry:
          (json['inventory_turnover_industry'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OperationalProfitabilityModel extends OperationalProfitabilityEntity {
  const OperationalProfitabilityModel({
    required super.metrics,
    required super.coreIndicators,
    required super.efficiency,
    required super.benchmark,
  });

  factory OperationalProfitabilityModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return OperationalProfitabilityModel(
      metrics: OperationalProfitabilityMetricsModel.fromJson(
        data['metrics'] as Map<String, dynamic>? ?? {},
      ),
      coreIndicators: OperationalProfitabilityCoreIndicatorsModel.fromJson(
        data['core_indicators'] as Map<String, dynamic>? ?? {},
      ),
      efficiency: OperationalProfitabilityEfficiencyModel.fromJson(
        data['efficiency'] as Map<String, dynamic>? ?? {},
      ),
      benchmark: OperationalProfitabilityBenchmarkModel.fromJson(
        data['benchmark'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
