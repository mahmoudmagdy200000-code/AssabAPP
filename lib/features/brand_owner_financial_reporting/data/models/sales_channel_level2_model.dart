import '../../domain/entities/sales_channel_level2_entity.dart';

class SalesChannelLevel2ChartDataModel
    extends SalesChannelLevel2ChartDataEntity {
  const SalesChannelLevel2ChartDataModel({
    required super.month,
    required super.value,
  });

  factory SalesChannelLevel2ChartDataModel.fromJson(Map<String, dynamic> json) {
    return SalesChannelLevel2ChartDataModel(
      month: DateTime.parse(json['month'] as String),
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SalesChannelLevel2ItemModel extends SalesChannelLevel2ItemEntity {
  const SalesChannelLevel2ItemModel({
    required super.id,
    required super.name,
    required super.image,
    required super.salesAmount,
    required super.percentageChange,
    required super.isPositive,
    required super.comparisonText,
    required super.commissionAmount,
    required super.commissionPercentage,
    required super.profitabilityAmount,
    required super.profitabilityPercentage,
    required super.orderCount,
    required super.averageOrderValue,
  });

  factory SalesChannelLevel2ItemModel.fromJson(Map<String, dynamic> json) {
    return SalesChannelLevel2ItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      salesAmount: (json['sales_amount'] as num?)?.toDouble() ?? 0.0,
      percentageChange: (json['percentage_change'] as num?)?.toDouble() ?? 0.0,
      isPositive: json['is_positive'] as bool? ?? true,
      comparisonText: json['comparison_text']?.toString() ?? '',
      commissionAmount: (json['commission_amount'] as num?)?.toDouble() ?? 0.0,
      commissionPercentage:
          (json['commission_percentage'] as num?)?.toDouble() ?? 0.0,
      profitabilityAmount:
          (json['profitability_amount'] as num?)?.toDouble() ?? 0.0,
      profitabilityPercentage:
          (json['profitability_percentage'] as num?)?.toDouble() ?? 0.0,
      orderCount: (json['order_count'] as num?)?.toInt() ?? 0,
      averageOrderValue:
          (json['average_order_value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SalesChannelLevel2Model extends SalesChannelLevel2Entity {
  const SalesChannelLevel2Model({
    required super.year,
    required super.month,
    required super.comparedYear,
    required super.comparedMonth,
    required super.monthName,
    required super.totalCount,
    required super.items,
    required super.chartData,
  });

  factory SalesChannelLevel2Model.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    final itemsList =
        (data['items'] as List<dynamic>?)
            ?.map(
              (e) => SalesChannelLevel2ItemModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList() ??
        [];

    final chartList =
        (data['chart_data'] as List<dynamic>?)
            ?.map(
              (e) => SalesChannelLevel2ChartDataModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList() ??
        [];

    return SalesChannelLevel2Model(
      year: data['year'] as int? ?? DateTime.now().year,
      month: data['month'] as int? ?? DateTime.now().month,
      comparedYear: data['compared_year'] as int? ?? DateTime.now().year,
      comparedMonth: data['compared_month'] as int? ?? DateTime.now().month - 1,
      monthName: data['month_name']?.toString() ?? '',
      totalCount: data['total_count'] as int? ?? itemsList.length,
      items: itemsList,
      chartData: chartList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'compared_year': comparedYear,
      'compared_month': comparedMonth,
    };
  }
}
