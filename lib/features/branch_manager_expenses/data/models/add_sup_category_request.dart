import 'package:json_annotation/json_annotation.dart';

part 'add_sup_category_request.g.dart';

@JsonSerializable()
class AddSupCategoryRequest {
  @JsonKey(name: 'parent_id')
  final String parentId;
  final String name;
  final String type;
  @JsonKey(name: 'is_active')
  final bool isActive;

  AddSupCategoryRequest({
    required this.parentId,
    required this.name,
    required this.type,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => _$AddSupCategoryRequestToJson(this);

  factory AddSupCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$AddSupCategoryRequestFromJson(json);
}
