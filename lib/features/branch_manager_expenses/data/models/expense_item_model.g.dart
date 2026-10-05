// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseItemModel _$ExpenseItemModelFromJson(Map<String, dynamic> json) =>
    ExpenseItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ExpenseItemModelToJson(ExpenseItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
    };
