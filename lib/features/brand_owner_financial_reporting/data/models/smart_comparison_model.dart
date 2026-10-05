import '../../domain/entities/smart_comparison_entity.dart';
import '../../domain/enums/brand_owner_smart_compare_type_enum.dart';

class SmartComparisonSummaryModel extends SmartComparisonSummaryEntity {
  const SmartComparisonSummaryModel({
    required super.totalSales,
    required super.totalProfitability,
    required super.totalProfitabilityPercentage,
    required super.netProfitPercentage,
    required super.profitMarginPercentage,
  });

  factory SmartComparisonSummaryModel.fromJson(Map<String, dynamic> json) {
    return SmartComparisonSummaryModel(
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

class SmartComparisonChartDataModel extends SmartComparisonChartDataEntity {
  const SmartComparisonChartDataModel({
    required super.mainMonth,
    required super.mainYear,
    required super.mainValue,
    required super.comparedMonth,
    required super.comparedYear,
    required super.comparedValue,
  });

  factory SmartComparisonChartDataModel.fromJson(Map<String, dynamic> json) {
    return SmartComparisonChartDataModel(
      mainMonth: json['main_month'] as int? ?? 0,
      mainYear: json['main_year'] as int? ?? 0,
      mainValue: (json['main_value'] as num?)?.toDouble() ?? 0.0,
      comparedMonth: json['compared_month'] as int? ?? 0,
      comparedYear: json['compared_year'] as int? ?? 0,
      comparedValue: (json['compared_value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SmartComparisonModel extends SmartComparisonEntity {
  const SmartComparisonModel({
    required super.year,
    required super.month,
    required super.comparedYear,
    required super.comparedMonth,
    required super.monthName,
    required super.comparedMonthName,
    required super.type,
    required super.branchId,
    required super.branchName,
    super.comparedBranchId,
    super.comparedBranchName,
    required super.summary,
    required super.chartData,
  });

  factory SmartComparisonModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final summaryJson = data['summary'] as Map<String, dynamic>?;

    return SmartComparisonModel(
      year: data['year'] as int? ?? DateTime
          .now()
          .year,
      month: data['month'] as int? ?? DateTime
          .now()
          .month,
      comparedYear: data['compared_year'] as int? ?? DateTime
          .now()
          .year,
      comparedMonth: data['compared_month'] as int? ?? DateTime
          .now()
          .month - 1,
      monthName: data['month_name']?.toString() ?? '',
      comparedMonthName: data['compared_month_name']?.toString() ?? '',
      type: BrandOwnerSmartCompareTypeEnum.fromValue(
        data['type']?.toString() ?? 'month',
      ),
      branchId: data['branch_id']?.toString() ?? '',
      branchName: data['branch_name']?.toString() ?? '',
      comparedBranchId: data['compared_branch_id']?.toString(),
      comparedBranchName: data['compared_branch_name']?.toString(),
      summary: summaryJson != null
          ? SmartComparisonSummaryModel.fromJson(summaryJson)
          : const SmartComparisonSummaryModel(
        totalSales: 0,
        totalProfitability: 0,
        totalProfitabilityPercentage: 0,
        netProfitPercentage: 0,
        profitMarginPercentage: 0,
      ),
      chartData: SmartComparisonChartDataModel.fromJson(
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
      'type': type.value,
      'branch_id': branchId,
      'compared_branch_id': comparedBranchId,
    };
  }
}
