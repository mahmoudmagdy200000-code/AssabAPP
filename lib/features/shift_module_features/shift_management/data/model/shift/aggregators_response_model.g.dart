// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aggregators_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AggregatorsResponseModel _$AggregatorsResponseModelFromJson(
  Map<String, dynamic> json,
) => AggregatorsResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => AggregatorModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AggregatorsResponseModelToJson(
  AggregatorsResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'meta': instance.meta,
};
