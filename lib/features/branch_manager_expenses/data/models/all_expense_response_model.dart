import 'package:assab/features/branch_manager_expenses/data/models/expense_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../shared/models/meta_model/meta_model.dart';

part 'all_expense_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AllExpenseResponseModel {
  final List<ExpenseDataModel> data;
  final MetaModel meta;

  AllExpenseResponseModel({required this.data, required this.meta});

  factory AllExpenseResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AllExpenseResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllExpenseResponseModelToJson(this);
}
