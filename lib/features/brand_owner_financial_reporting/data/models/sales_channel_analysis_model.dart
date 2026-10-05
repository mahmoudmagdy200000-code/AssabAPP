import '../../domain/entities/sales_channel_analysis_entity.dart';

class SalesChannelAnalysisSummaryModel
    extends SalesChannelAnalysisSummaryEntity {
  const SalesChannelAnalysisSummaryModel({
    required super.totalSales,
    required super.totalProfitability,
    required super.totalProfitabilityPercentage,
    required super.netProfitPercentage,
    required super.profitMarginPercentage,
  });

  factory SalesChannelAnalysisSummaryModel.fromJson(Map<String, dynamic> json) {
    return SalesChannelAnalysisSummaryModel(
      totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0.0,
      totalProfitability:
          (json['total_profitability'] as num?)?.toDouble() ?? 0.0,
      totalProfitabilityPercentage:
          (json['total_profitability_percentage'] as num?)?.toDouble() ?? 0.0,
      netProfitPercentage:
          (json['net_profit_percentage'] as num?)?.toDouble() ?? 0.0,
      profitMarginPercentage:
          (json['profit_margin_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SalesChannelAnalysisChartDataModel
    extends SalesChannelAnalysisChartDataEntity {
  const SalesChannelAnalysisChartDataModel({
    required super.mainMonth,
    required super.mainYear,
    required super.mainValue,
    required super.comparedMonth,
    required super.comparedYear,
    required super.comparedValue,
  });

  factory SalesChannelAnalysisChartDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SalesChannelAnalysisChartDataModel(
      mainMonth: json['main_month'] as int? ?? 0,
      mainYear: json['main_year'] as int? ?? 0,
      mainValue: (json['main_value'] as num?)?.toDouble() ?? 0.0,
      comparedMonth: json['compared_month'] as int? ?? 0,
      comparedYear: json['compared_year'] as int? ?? 0,
      comparedValue: (json['compared_value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SalesChannelAnalysisModel extends SalesChannelAnalysisEntity {
  const SalesChannelAnalysisModel({
    required super.year,
    required super.month,
    required super.comparedYear,
    required super.comparedMonth,
    required super.monthName,
    required super.branchId,
    required super.branchName,
    required super.summary,
    required super.chartData,
  });

  factory SalesChannelAnalysisModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final summaryJson = data['summary'] as Map<String, dynamic>?;

    return SalesChannelAnalysisModel(
      year: data['year'] as int? ?? DateTime.now().year,
      month: data['month'] as int? ?? DateTime.now().month,
      comparedYear: data['compared_year'] as int? ?? DateTime.now().year,
      comparedMonth: data['compared_month'] as int? ?? DateTime.now().month - 1,
      monthName: data['month_name']?.toString() ?? '',
      branchId: data['branch_id']?.toString() ?? '',
      branchName: data['branch_name']?.toString() ?? '',
      summary: summaryJson != null
          ? SalesChannelAnalysisSummaryModel.fromJson(summaryJson)
          : const SalesChannelAnalysisSummaryModel(
              totalSales: 0,
              totalProfitability: 0,
              totalProfitabilityPercentage: 0,
              netProfitPercentage: 0,
              profitMarginPercentage: 0,
            ),
      chartData: SalesChannelAnalysisChartDataModel.fromJson(
        data['chart_data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'compared_year': comparedYear,
      'compared_month': comparedMonth,
      'branch_id': branchId,
    };
  }
}
