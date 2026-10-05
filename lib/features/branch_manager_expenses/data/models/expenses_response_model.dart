import 'package:json_annotation/json_annotation.dart';

import 'expense_data_model.dart';

part 'expenses_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExpensesResponseModel {
  final List<ExpenseDataModel> data;

  ExpensesResponseModel({required this.data});

  factory ExpensesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpensesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpensesResponseModelToJson(this);
}
