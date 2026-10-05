// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierModel _$CashierModelFromJson(Map<String, dynamic> json) => CashierModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  branchName: json['store_branch_name'] as String?,
  branchId: json['store_branch_id'] as String?,
  createdAt: json['created_at'] as String?,
  createdByName: json['created_by_name'] as String?,
  statusLabel: json['status_label'] as String?,
  image: json['image'] as String?,
  status: $enumDecodeNullable(_$CashierStatusEnumMap, json['status']),
  shiftsCount: (json['number_of_shifts_per_day'] as num?)?.toInt(),
  workingShifts: (json['working_shifts'] as List<dynamic>?)
      ?.map((e) => WorkingShiftModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CashierModelToJson(CashierModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'image': instance.image,
      'status': _$CashierStatusEnumMap[instance.status],
      'store_branch_name': instance.branchName,
      'created_by_name': instance.createdByName,
      'store_branch_id': instance.branchId,
      'number_of_shifts_per_day': instance.shiftsCount,
      'status_label': instance.statusLabel,
      'created_at': instance.createdAt,
      'working_shifts': instance.workingShifts?.map((e) => e.toJson()).toList(),
    };

const _$CashierStatusEnumMap = {
  CashierStatus.active: 'active',
  CashierStatus.pending: 'pending',
  CashierStatus.deactivated: 'deactivated',
};
