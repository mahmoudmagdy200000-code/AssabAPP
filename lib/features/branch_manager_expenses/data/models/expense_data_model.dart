import 'package:assab/features/branch_manager_expenses/data/models/expense_status_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/enums/expenses_steragies_keys.dart';
import '../../domain/entities/expenses_entity.dart';
import 'expense_type_model.dart';

part 'expense_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ExpenseDataModel {
  final String id;

  @JsonKey(name: 'expense_name')
  final String expenseName;

  @JsonKey(name: 'expense_type')
  final ExpenseTypeModel expenseType;

  final double amount;
  final String date;
  final String time;
  final ExpenseStatusModel status;

  @JsonKey(name: 'created_at')
  final String createdAt;

  ExpenseDataModel({
    required this.id,
    required this.expenseName,
    required this.expenseType,
    required this.amount,
    required this.date,
    required this.time,
    required this.status,
    required this.createdAt,
  });

  factory ExpenseDataModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseDataModelToJson(this);

  ExpensesEntity toEntity() {
    return ExpensesEntity(
      id: id,
      expenseName: expenseName,
      expenseType: ExpensesStrategiesKeys.fromType(expenseType.value).strategy,
      amount: amount,
      date: date,
      time: time,
      status: status.value,
      createdAt: createdAt,
    );
  }
}
