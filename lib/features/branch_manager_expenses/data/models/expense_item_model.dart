import 'package:json_annotation/json_annotation.dart';

part 'expense_item_model.g.dart';

@JsonSerializable()
class ExpenseItemModel {
  final String id;
  final String title;
  final double amount;

  const ExpenseItemModel({
    required this.id,
    required this.title,
    required this.amount,
  });

  factory ExpenseItemModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseItemModelToJson(this);
}
