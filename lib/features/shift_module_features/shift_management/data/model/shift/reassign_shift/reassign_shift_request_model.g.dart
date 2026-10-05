// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reassign_shift_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReassignShiftRequestModel _$ReassignShiftRequestModelFromJson(
  Map<String, dynamic> json,
) => ReassignShiftRequestModel(
  newCashierId: json['new_cashier_id'] as String,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$ReassignShiftRequestModelToJson(
  ReassignShiftRequestModel instance,
) => <String, dynamic>{
  'new_cashier_id': instance.newCashierId,
  'reason': instance.reason,
};
