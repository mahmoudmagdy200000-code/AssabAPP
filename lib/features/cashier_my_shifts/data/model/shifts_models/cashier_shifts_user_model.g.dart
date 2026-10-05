// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_shifts_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierShiftUserModel _$CashierShiftUserModelFromJson(
  Map<String, dynamic> json,
) => CashierShiftUserModel(
  id: json['id'] as String?,
  name: json['name'] as String,
  userType: UserType.fromJson(json['user_type'] as String?),
  type: UserType.fromJson(json['type'] as String?),
);

Map<String, dynamic> _$CashierShiftUserModelToJson(
  CashierShiftUserModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'user_type': _$UserTypeEnumMap[instance.userType],
  'type': _$UserTypeEnumMap[instance.type],
};

const _$UserTypeEnumMap = {
  UserType.cashier: 'cashier',
  UserType.manager: 'manager',
};
