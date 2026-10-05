// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierDetailsModel _$CashierDetailsModelFromJson(Map<String, dynamic> json) =>
    CashierDetailsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      varianceReason: json['variance_reason'] as String?,
    );

Map<String, dynamic> _$CashierDetailsModelToJson(
  CashierDetailsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'variance_reason': instance.varianceReason,
};
