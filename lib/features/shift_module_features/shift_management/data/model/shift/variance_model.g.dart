// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Variance _$VarianceFromJson(Map<String, dynamic> json) => Variance(
  responsibilityType: json['responsibility_type'] as String,
  currentCashierAmount: (json['current_cashier_amount'] as num?)?.toDouble(),
  reason: json['reason'] as String,
  otherCashiers: (json['other_cashiers'] as List<dynamic>)
      .map((e) => OtherCashier.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VarianceToJson(Variance instance) => <String, dynamic>{
  'responsibility_type': instance.responsibilityType,
  'current_cashier_amount': instance.currentCashierAmount,
  'reason': instance.reason,
  'other_cashiers': instance.otherCashiers.map((e) => e.toJson()).toList(),
};

OtherCashier _$OtherCashierFromJson(Map<String, dynamic> json) => OtherCashier(
  cashierId: json['cashier_id'] as String,
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$OtherCashierToJson(OtherCashier instance) =>
    <String, dynamic>{
      'cashier_id': instance.cashierId,
      'amount': instance.amount,
    };
