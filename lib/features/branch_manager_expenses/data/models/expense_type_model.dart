import 'package:json_annotation/json_annotation.dart';

part 'expense_type_model.g.dart';

@JsonSerializable()
class ExpenseTypeModel {
  final String value;
  final String label;

  ExpenseTypeModel({required this.value, required this.label});

  factory ExpenseTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseTypeModelToJson(this);
}
