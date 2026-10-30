// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_breakdown_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierBreakdownRequestModel _$CashierBreakdownRequestModelFromJson(
  Map<String, dynamic> json,
) => CashierBreakdownRequestModel(
  aggregators: (json['aggregators'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  cashierId: json['cashier_id'] as String,
  cashierShiftId: json['cashier_shift_id'] as String?,
  cashCollected: (json['cash_collected'] as num?)?.toDouble(),
  cardPayments: (json['card_payments'] as num?)?.toDouble(),
  deliveryAppPayments: (json['delivery_app_payments'] as num?)?.toDouble(),
  sales: (json['sales'] as num?)?.toDouble(),
  expectedRevision: (json['expected_revision'] as num?)?.toInt(),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$CashierBreakdownRequestModelToJson(
  CashierBreakdownRequestModel instance,
) => <String, dynamic>{
  'aggregators': ?instance.aggregators,
  'cashier_id': instance.cashierId,
  'cashier_shift_id': ?instance.cashierShiftId,
  'cash_collected': instance.cashCollected,
  'card_payments': instance.cardPayments,
  'delivery_app_payments': instance.deliveryAppPayments,
  'sales': instance.sales,
  'expected_revision': ?instance.expectedRevision,
  'reason': ?instance.reason,
};
