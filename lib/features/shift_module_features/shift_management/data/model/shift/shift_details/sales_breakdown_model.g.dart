// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_breakdown_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesBreakdownModel _$SalesBreakdownModelFromJson(Map<String, dynamic> json) =>
    SalesBreakdownModel(
      id: (json['id'] as num).toInt(),
      aggregator: json['aggregator'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$SalesBreakdownModelToJson(
  SalesBreakdownModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'aggregator': instance.aggregator,
  'amount': instance.amount,
};
