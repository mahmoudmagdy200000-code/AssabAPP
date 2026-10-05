// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_cashier_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCashierRequestModel _$AddCashierRequestModelFromJson(
  Map<String, dynamic> json,
) => AddCashierRequestModel(
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  branchId: json['store_branch_id'] as String,
  shiftIds: (json['shift_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$AddCashierRequestModelToJson(
  AddCashierRequestModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'store_branch_id': instance.branchId,
  'shift_ids': instance.shiftIds,
};
