// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_expense_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllExpenseResponseModel _$AllExpenseResponseModelFromJson(
  Map<String, dynamic> json,
) => AllExpenseResponseModel(
  data: (json['data'] as List<dynamic>)
      .map((e) => ExpenseDataModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AllExpenseResponseModelToJson(
  AllExpenseResponseModel instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};
