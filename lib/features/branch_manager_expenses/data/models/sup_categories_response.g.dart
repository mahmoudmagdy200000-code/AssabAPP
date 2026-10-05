// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sup_categories_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupCategoriesResponse _$SupCategoriesResponseFromJson(
  Map<String, dynamic> json,
) => SupCategoriesResponse(
  data: SupCategoriesResponseData.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SupCategoriesResponseToJson(
  SupCategoriesResponse instance,
) => <String, dynamic>{'data': instance.data};

SupCategoriesResponseData _$SupCategoriesResponseDataFromJson(
  Map<String, dynamic> json,
) => SupCategoriesResponseData(
  parent: ParentCategory.fromJson(json['parent'] as Map<String, dynamic>),
  subcategories: (json['subcategories'] as List<dynamic>)
      .map((e) => SupCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SupCategoriesResponseDataToJson(
  SupCategoriesResponseData instance,
) => <String, dynamic>{
  'parent': instance.parent,
  'subcategories': instance.subcategories,
};

ParentCategory _$ParentCategoryFromJson(Map<String, dynamic> json) =>
    ParentCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ParentCategoryToJson(ParentCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
    };

SupCategory _$SupCategoryFromJson(Map<String, dynamic> json) => SupCategory(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$SupCategoryToJson(SupCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'is_active': instance.isActive,
    };
