// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseStatusModel _$ExpenseStatusModelFromJson(Map<String, dynamic> json) =>
    ExpenseStatusModel(
      value: json['value'] as String,
      label: json['label'] as String,
      color: json['color'] as String,
    );

Map<String, dynamic> _$ExpenseStatusModelToJson(ExpenseStatusModel instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
      'color': instance.color,
    };
