import 'package:json_annotation/json_annotation.dart';

part 'meta_model.g.dart';

@JsonSerializable()
class MetaModel {
  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'last_page')
  final int lastPage;

  final int total;

  MetaModel({
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) =>
      _$MetaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetaModelToJson(this);
}
