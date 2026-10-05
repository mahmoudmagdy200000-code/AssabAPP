// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_shift_aggregator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EndShiftAggregatorModel _$EndShiftAggregatorModelFromJson(
  Map<String, dynamic> json,
) => EndShiftAggregatorModel(
  aggregatorId: json['aggregator_id'] as String,
  amount: (json['amount'] as num).toDouble(),
  notes: json['notes'] as String,
);

Map<String, dynamic> _$EndShiftAggregatorModelToJson(
  EndShiftAggregatorModel instance,
) => <String, dynamic>{
  'aggregator_id': instance.aggregatorId,
  'amount': instance.amount,
  'notes': instance.notes,
};
