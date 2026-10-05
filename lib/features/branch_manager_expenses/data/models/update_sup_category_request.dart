import 'package:json_annotation/json_annotation.dart';

part 'update_sup_category_request.g.dart';

@JsonSerializable()
class UpdateSupCategoryRequest {
  @JsonKey(name: 'parent_id')
  final String parentId;
  final String name;
  final String type;
  @JsonKey(name: 'is_active')
  final bool isActive;

  UpdateSupCategoryRequest({
    required this.parentId,
    required this.name,
    required this.type,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => _$UpdateSupCategoryRequestToJson(this);

  factory UpdateSupCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateSupCategoryRequestFromJson(json);
}
