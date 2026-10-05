// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpensesResponseModel _$ExpensesResponseModelFromJson(
  Map<String, dynamic> json,
) => ExpensesResponseModel(
  data: (json['data'] as List<dynamic>)
      .map((e) => ExpenseDataModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExpensesResponseModelToJson(
  ExpensesResponseModel instance,
) => <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};
