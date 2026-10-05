// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variance_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VarianceDetailsModel _$VarianceDetailsModelFromJson(
  Map<String, dynamic> json,
) => VarianceDetailsModel(
  id: (json['id'] as num).toInt(),
  responsibleCashier: json['responsible_cashier'] as String,
  amount: (json['amount'] as num).toDouble(),
  reason: json['reason'] as String,
);

Map<String, dynamic> _$VarianceDetailsModelToJson(
  VarianceDetailsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'responsible_cashier': instance.responsibleCashier,
  'amount': instance.amount,
  'reason': instance.reason,
};
