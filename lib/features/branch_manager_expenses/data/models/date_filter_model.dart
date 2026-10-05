import 'package:json_annotation/json_annotation.dart';

part 'date_filter_model.g.dart';

@JsonSerializable()
class DateFilterModel {
  final int month;
  final int year;

  DateFilterModel({required this.month, required this.year});

  factory DateFilterModel.fromJson(Map<String, dynamic> json) =>
      _$DateFilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$DateFilterModelToJson(this);
}
