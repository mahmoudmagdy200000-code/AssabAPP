import '../../domain/entities/brand_owner_break_even_analysis_entity.dart';

class BreakEvenAnalysisMetricsModel extends BreakEvenAnalysisMetricsEntity {
  const BreakEvenAnalysisMetricsModel({
    required super.currentPointX,
    required super.currentPointY,
    required super.fixedCostX,
    required super.fixedCostY,
  });

  factory BreakEvenAnalysisMetricsModel.fromJson(Map<String, dynamic> json) {
    return BreakEvenAnalysisMetricsModel(
      currentPointX: (json['current_point_x'] as num?)?.toDouble() ?? 0.0,
      currentPointY: (json['current_point_y'] as num?)?.toDouble() ?? 0.0,
      fixedCostX: (json['fixed_cost_x'] as num?)?.toDouble() ?? 0.0,
      fixedCostY: (json['fixed_cost_y'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class BreakEvenAnalysisFixedCostsModel
    extends BreakEvenAnalysisFixedCostsEntity {
  const BreakEvenAnalysisFixedCostsModel({
    required super.rentAndUtilities,
    required super.salaries,
    required super.insuranceAndLicenses,
    required super.totalFixed,
  });

  factory BreakEvenAnalysisFixedCostsModel.fromJson(Map<String, dynamic> json) {
    return BreakEvenAnalysisFixedCostsModel(
      rentAndUtilities: (json['rent_and_utilities'] as num?)?.toDouble() ?? 0.0,
      salaries: (json['salaries'] as num?)?.toDouble() ?? 0.0,
      insuranceAndLicenses:
          (json['insurance_and_licenses'] as num?)?.toDouble() ?? 0.0,
      totalFixed: (json['total_fixed'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class BreakEvenAnalysisContributionMarginModel
    extends BreakEvenAnalysisContributionMarginEntity {
  const BreakEvenAnalysisContributionMarginModel({
    required super.grossProfitMargin,
    required super.variableCosts,
  });

  factory BreakEvenAnalysisContributionMarginModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BreakEvenAnalysisContributionMarginModel(
      grossProfitMargin:
          (json['gross_profit_margin'] as num?)?.toDouble() ?? 0.0,
      variableCosts: (json['variable_costs'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class BreakEvenAnalysisFormulaModel extends BreakEvenAnalysisFormulaEntity {
  const BreakEvenAnalysisFormulaModel({
    required super.fixedCosts,
    required super.contributionMargin,
    required super.result,
  });

  factory BreakEvenAnalysisFormulaModel.fromJson(Map<String, dynamic> json) {
    return BreakEvenAnalysisFormulaModel(
      fixedCosts: (json['fixed_costs'] as num?)?.toDouble() ?? 0.0,
      contributionMargin:
          (json['contribution_margin'] as num?)?.toDouble() ?? 0.0,
      result: (json['result'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class BreakEvenAnalysisModel extends BreakEvenAnalysisEntity {
  const BreakEvenAnalysisModel({
    required super.year,
    required super.month,
    required super.monthName,
    required super.previousMonthName,
    required super.branchId,
    required super.branchName,
    required super.status,
    required super.currentPointPosition,
    required super.metrics,
    required super.fixedCosts,
    required super.contributionMargin,
    required super.formula,
  });

  factory BreakEvenAnalysisModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return BreakEvenAnalysisModel(
      year: data['year'] as int? ?? DateTime.now().year,
      month: data['month'] as int? ?? DateTime.now().month,
      monthName: data['month_name']?.toString() ?? '',
      previousMonthName: data['previous_month_name']?.toString() ?? '',
      branchId: data['branch_id']?.toString() ?? '',
      branchName: data['branch_name']?.toString() ?? '',
      status: data['status']?.toString() ?? 'very_safe',
      currentPointPosition:
          (data['current_point_position'] as num?)?.toDouble() ?? 0,
      metrics: BreakEvenAnalysisMetricsModel.fromJson(
        data['metrics'] as Map<String, dynamic>? ?? {},
      ),
      fixedCosts: BreakEvenAnalysisFixedCostsModel.fromJson(
        data['fixed_costs'] as Map<String, dynamic>? ?? {},
      ),
      contributionMargin: BreakEvenAnalysisContributionMarginModel.fromJson(
        data['contribution_margin'] as Map<String, dynamic>? ?? {},
      ),
      formula: BreakEvenAnalysisFormulaModel.fromJson(
        data['formula'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
