// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_totals_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyTotalsModel _$DailyTotalsModelFromJson(Map<String, dynamic> json) =>
    DailyTotalsModel(
      totalCashCollected: (json['total_cash_collected'] as num?)?.toDouble(),
      totalCardPayments: (json['total_card_payments'] as num?)?.toDouble(),
      totalDeliveryApps: (json['total_delivery_apps'] as num?)?.toDouble(),
      totalVariance: (json['total_variance'] as num?)?.toDouble(),
      totalSales: (json['total_sales'] as num?)?.toDouble(),
      shiftDate: json['shift_date'] as String?,
    );

Map<String, dynamic> _$DailyTotalsModelToJson(DailyTotalsModel instance) =>
    <String, dynamic>{
      'total_cash_collected': instance.totalCashCollected,
      'total_card_payments': instance.totalCardPayments,
      'total_delivery_apps': instance.totalDeliveryApps,
      'total_variance': instance.totalVariance,
      'total_sales': instance.totalSales,
      'shift_date': instance.shiftDate,
    };
