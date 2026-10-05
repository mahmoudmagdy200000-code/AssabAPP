import '../../domain/entities/profit_and_loss_statement_entity.dart';

class ProfitAndLossSummaryModel extends ProfitAndLossSummaryEntity {
  const ProfitAndLossSummaryModel({
    required super.totalRevenue,
    required super.totalExpenses,
    required super.netProfit,
    required super.profitMarginPercentage,
    required super.isProfit,
  });

  factory ProfitAndLossSummaryModel.fromJson(Map<String, dynamic> json) {
    final totalRevenue = (json['total_revenue'] as num?)?.toDouble() ?? 0.0;
    final totalExpenses = (json['total_expenses'] as num?)?.toDouble() ?? 0.0;
    final netProfit = (json['net_profit'] as num?)?.toDouble() ?? 0.0;

    return ProfitAndLossSummaryModel(
      totalRevenue: totalRevenue,
      totalExpenses: totalExpenses,
      netProfit: netProfit,
      profitMarginPercentage:
          (json['profit_margin_percentage'] as num?)?.toDouble() ?? 0.0,
      isProfit: json['is_profit'] as bool? ?? netProfit >= 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_revenue': totalRevenue,
      'total_expenses': totalExpenses,
      'net_profit': netProfit,
      'profit_margin_percentage': profitMarginPercentage,
      'is_profit': isProfit,
    };
  }
}

class ProfitAndLossChartModel extends ProfitAndLossChartEntity {
  const ProfitAndLossChartModel({
    required super.turnoverTotal,
    required super.directCostTotal,
    required super.grossProfit,
    required super.grandTotalCost,
    required super.profitabilityAmount,
    required super.gAndAExpenses,
    required super.otherIncomeExpenses,
    required super.netProfitAndLoss,
  });

  factory ProfitAndLossChartModel.fromJson(Map<String, dynamic> json) {
    return ProfitAndLossChartModel(
      turnoverTotal: (json['turnover_total'] as num?)?.toDouble() ?? 0.0,
      directCostTotal: (json['direct_cost_total'] as num?)?.toDouble() ?? 0.0,
      grossProfit: (json['gross_profit'] as num?)?.toDouble() ?? 0.0,
      grandTotalCost: (json['grand_total_cost'] as num?)?.toDouble() ?? 0.0,
      profitabilityAmount:
          (json['profitability_amount'] as num?)?.toDouble() ?? 0.0,
      gAndAExpenses: (json['g_and_a_expenses'] as num?)?.toDouble() ?? 0.0,
      otherIncomeExpenses:
          (json['other_income_expenses'] as num?)?.toDouble() ?? 0.0,
      netProfitAndLoss:
          (json['net_profit_and_loss'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ProfitAndLossStatementModel extends ProfitAndLossStatementEntity {
  const ProfitAndLossStatementModel({
    required super.year,
    required super.month,
    required super.branchId,
    required super.branchName,
    required super.summary,
    required super.chart,
  });

  factory ProfitAndLossStatementModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final summaryJson = data?['summary'] as Map<String, dynamic>?;

    return ProfitAndLossStatementModel(
      year: data?['year'] as int? ?? DateTime.now().year,
      month: data?['month'] as int? ?? DateTime.now().month,
      branchId: (data?['branch_id'] ?? data?['branchId'] ?? '')?.toString() ?? '',
      branchName: (data?['branch_name'] ?? data?['branchName'] ?? '')?.toString() ?? '',
      summary: summaryJson != null
          ? ProfitAndLossSummaryModel.fromJson(summaryJson)
          : const ProfitAndLossSummaryModel(
        totalRevenue: 0,
        totalExpenses: 0,
        netProfit: 0,
        profitMarginPercentage: 0,
        isProfit: true,
      ),
      chart: ProfitAndLossChartModel.fromJson(
        data?['chart'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'summary': (summary as ProfitAndLossSummaryModel).toJson(),
    };
  }
}
