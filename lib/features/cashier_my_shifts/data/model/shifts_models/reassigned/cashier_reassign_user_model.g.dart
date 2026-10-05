// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_reassign_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierReassignUserModel _$CashierReassignUserModelFromJson(
  Map<String, dynamic> json,
) => CashierReassignUserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  userType: UserType.fromJson(json['user_type'] as String?),
);

Map<String, dynamic> _$CashierReassignUserModelToJson(
  CashierReassignUserModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'user_type': _$UserTypeEnumMap[instance.userType],
};

const _$UserTypeEnumMap = {
  UserType.cashier: 'cashier',
  UserType.manager: 'manager',
};
