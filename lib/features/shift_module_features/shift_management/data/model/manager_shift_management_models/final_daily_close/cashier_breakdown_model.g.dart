// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_breakdown_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierBreakdownModel _$CashierBreakdownModelFromJson(
  Map<String, dynamic> json,
) => CashierBreakdownModel(
  cashierId: json['cashier_id'] as String,
  cashierShiftId: json['cashier_shift_id'] as String?,
  expectedRevision: (json['expected_revision'] as num?)?.toInt(),
  cashierName: json['cashier_name'] as String,
  cashCollected: (json['cash_collected'] as num?)?.toDouble(),
  cardPayments: (json['card_payments'] as num?)?.toDouble(),
  deliveryAppPayments: (json['delivery_app_payments'] as num?)?.toDouble(),
  variance: (json['variance'] as num?)?.toDouble(),
  sales: (json['sales'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CashierBreakdownModelToJson(
  CashierBreakdownModel instance,
) => <String, dynamic>{
  'cashier_id': instance.cashierId,
  'cashier_shift_id': instance.cashierShiftId,
  'expected_revision': instance.expectedRevision,
  'cashier_name': instance.cashierName,
  'cash_collected': instance.cashCollected,
  'card_payments': instance.cardPayments,
  'delivery_app_payments': instance.deliveryAppPayments,
  'sales': instance.sales,
};
