// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_categories_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseCategoriesResponseModel _$ExpenseCategoriesResponseModelFromJson(
  Map<String, dynamic> json,
) => ExpenseCategoriesResponseModel(
  data: (json['data'] as List<dynamic>)
      .map((e) => ExpenseCategoryData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExpenseCategoriesResponseModelToJson(
  ExpenseCategoriesResponseModel instance,
) => <String, dynamic>{'data': instance.data};

ExpenseCategoryData _$ExpenseCategoryDataFromJson(Map<String, dynamic> json) =>
    ExpenseCategoryData(
      id: json['id'] as String,
      name: json['name'] as String,
      parent: json['parent'] == null
          ? null
          : ParentCategory.fromJson(json['parent'] as Map<String, dynamic>),
      type: json['type'] as String,
    );

Map<String, dynamic> _$ExpenseCategoryDataToJson(
  ExpenseCategoryData instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'parent': instance.parent,
  'type': instance.type,
};

ParentCategory _$ParentCategoryFromJson(Map<String, dynamic> json) =>
    ParentCategory(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$ParentCategoryToJson(ParentCategory instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
