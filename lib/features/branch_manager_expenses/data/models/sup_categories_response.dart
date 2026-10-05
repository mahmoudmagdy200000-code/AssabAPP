import 'package:json_annotation/json_annotation.dart';

part 'sup_categories_response.g.dart';

@JsonSerializable()
class SupCategoriesResponse {
  final SupCategoriesResponseData data;

  SupCategoriesResponse({required this.data});

  factory SupCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$SupCategoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SupCategoriesResponseToJson(this);
}

@JsonSerializable()
class SupCategoriesResponseData {
  final ParentCategory parent;
  final List<SupCategory> subcategories;

  SupCategoriesResponseData({
    required this.parent,
    required this.subcategories,
  });

  factory SupCategoriesResponseData.fromJson(Map<String, dynamic> json) =>
      _$SupCategoriesResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$SupCategoriesResponseDataToJson(this);
}

@JsonSerializable()
class ParentCategory {
  final String id;
  final String name;
  final String type;

  ParentCategory({required this.id, required this.name, required this.type});

  factory ParentCategory.fromJson(Map<String, dynamic> json) =>
      _$ParentCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ParentCategoryToJson(this);
}

@JsonSerializable()
class SupCategory {
  final String id;
  final String name;
  final String type;
  @JsonKey(name: 'is_active')
  final bool isActive;

  SupCategory({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
  });

  factory SupCategory.fromJson(Map<String, dynamic> json) =>
      _$SupCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SupCategoryToJson(this);
}
