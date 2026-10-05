// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_cashier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtherCashierModel _$OtherCashierModelFromJson(Map<String, dynamic> json) =>
    OtherCashierModel(
      cashierId: json['cashier_id'] as String?,
      cashierName: json['cashier_name'] as String?,
      amount: (json['amount'] as num).toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$OtherCashierModelToJson(OtherCashierModel instance) =>
    <String, dynamic>{
      'cashier_id': instance.cashierId,
      'cashier_name': instance.cashierName,
      'amount': instance.amount,
      'notes': instance.notes,
    };
