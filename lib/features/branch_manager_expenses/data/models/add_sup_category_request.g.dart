// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_sup_category_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddSupCategoryRequest _$AddSupCategoryRequestFromJson(
  Map<String, dynamic> json,
) => AddSupCategoryRequest(
  parentId: json['parent_id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$AddSupCategoryRequestToJson(
  AddSupCategoryRequest instance,
) => <String, dynamic>{
  'parent_id': instance.parentId,
  'name': instance.name,
  'type': instance.type,
  'is_active': instance.isActive,
};
