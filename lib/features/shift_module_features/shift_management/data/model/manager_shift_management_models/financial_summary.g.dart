// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialSummary _$FinancialSummaryFromJson(Map<String, dynamic> json) =>
    FinancialSummary(
      totalSales: json['total_sales'] as num,
      netSales: json['net_sales'] as num,
      vatAmount: json['vat_amount'] as num,
      cashCollected: json['cash_collected'] as num,
      cardPayments: json['card_payments'] as num,
      aggregatorPayments: json['aggregator_payments'] as num,
      totalVariance: json['total_variance'] as num,
    );

Map<String, dynamic> _$FinancialSummaryToJson(FinancialSummary instance) =>
    <String, dynamic>{
      'total_sales': instance.totalSales,
      'net_sales': instance.netSales,
      'vat_amount': instance.vatAmount,
      'cash_collected': instance.cashCollected,
      'card_payments': instance.cardPayments,
      'aggregator_payments': instance.aggregatorPayments,
      'total_variance': instance.totalVariance,
    };
