import 'package:json_annotation/json_annotation.dart';

part 'pagination_model.g.dart';

@JsonSerializable(includeIfNull: false)
class PaginationModel {
  final int? page;
  final int? perPage;

  PaginationModel({this.page, this.perPage});

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}
