// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_sup_category_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateSupCategoryRequest _$UpdateSupCategoryRequestFromJson(
  Map<String, dynamic> json,
) => UpdateSupCategoryRequest(
  parentId: json['parent_id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$UpdateSupCategoryRequestToJson(
  UpdateSupCategoryRequest instance,
) => <String, dynamic>{
  'parent_id': instance.parentId,
  'name': instance.name,
  'type': instance.type,
  'is_active': instance.isActive,
};
