import 'package:json_annotation/json_annotation.dart';

part 'expense_status_model.g.dart';

@JsonSerializable()
class ExpenseStatusModel {
  final String value;
  final String label;
  final String color;

  ExpenseStatusModel({
    required this.value,
    required this.label,
    required this.color,
  });

  factory ExpenseStatusModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseStatusModelToJson(this);
}
