import 'package:json_annotation/json_annotation.dart';

part 'expense_categories_response_model.g.dart';

@JsonSerializable()
class ExpenseCategoriesResponseModel {
  final List<ExpenseCategoryData> data;

  ExpenseCategoriesResponseModel({required this.data});

  factory ExpenseCategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoriesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseCategoriesResponseModelToJson(this);
}

@JsonSerializable()
class ExpenseCategoryData {
  final String id;
  final String name;
  final ParentCategory? parent;
  final String type;

  ExpenseCategoryData({
    required this.id,
    required this.name,
    this.parent,
    required this.type,
  });

  factory ExpenseCategoryData.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseCategoryDataToJson(this);
}

@JsonSerializable()
class ParentCategory {
  final String id;
  final String name;

  ParentCategory({required this.id, required this.name});

  factory ParentCategory.fromJson(Map<String, dynamic> json) =>
      _$ParentCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ParentCategoryToJson(this);
}
