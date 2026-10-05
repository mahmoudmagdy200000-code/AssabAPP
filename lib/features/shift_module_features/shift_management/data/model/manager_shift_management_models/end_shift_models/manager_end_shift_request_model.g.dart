// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_end_shift_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EndManagerShiftRequestModel _$EndManagerShiftRequestModelFromJson(
  Map<String, dynamic> json,
) => EndManagerShiftRequestModel(
  handoverTo: json['handover_to'] as String?,
  handoverAmount: (json['handover_amount'] as num?)?.toDouble(),
  handoverTiming: $enumDecode(_$HandoverTimingEnumMap, json['handover_timing']),
  handoverNotes: json['handover_notes'] as String?,
  totalSales: (json['total_sales'] as num?)?.toDouble(),
  cashCollected: (json['cash_collected'] as num?)?.toDouble(),
  cardPayments: (json['card_payments'] as num?)?.toDouble(),
  aggregatorPayments: (json['aggregator_payments'] as num?)?.toDouble(),
  cashierBreakdown: (json['cashier_breakdown'] as List<dynamic>?)
      ?.map((e) => CashierBreakdownModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EndManagerShiftRequestModelToJson(
  EndManagerShiftRequestModel instance,
) => <String, dynamic>{
  'handover_to': instance.handoverTo,
  'handover_amount': instance.handoverAmount,
  'handover_timing': _$HandoverTimingEnumMap[instance.handoverTiming]!,
  'handover_notes': instance.handoverNotes,
  'total_sales': instance.totalSales,
  'cash_collected': instance.cashCollected,
  'card_payments': instance.cardPayments,
  'aggregator_payments': instance.aggregatorPayments,
  'cashier_breakdown': instance.cashierBreakdown
      ?.map((e) => e.toJson())
      .toList(),
};

const _$HandoverTimingEnumMap = {
  HandoverTiming.today: 'today',
  HandoverTiming.yesterday: 'yesterday',
};
