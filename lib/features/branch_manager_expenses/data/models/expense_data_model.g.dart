// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseDataModel _$ExpenseDataModelFromJson(Map<String, dynamic> json) =>
    ExpenseDataModel(
      id: json['id'] as String,
      expenseName: json['expense_name'] as String,
      expenseType: ExpenseTypeModel.fromJson(
        json['expense_type'] as Map<String, dynamic>,
      ),
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] as String,
      time: json['time'] as String,
      status: ExpenseStatusModel.fromJson(
        json['status'] as Map<String, dynamic>,
      ),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$ExpenseDataModelToJson(ExpenseDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expense_name': instance.expenseName,
      'expense_type': instance.expenseType.toJson(),
      'amount': instance.amount,
      'date': instance.date,
      'time': instance.time,
      'status': instance.status.toJson(),
      'created_at': instance.createdAt,
    };
