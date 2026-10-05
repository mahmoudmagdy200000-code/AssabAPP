// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashiers_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashiersResponseModel _$CashiersResponseModelFromJson(
  Map<String, dynamic> json,
) => CashiersResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => CashierModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CashiersResponseModelToJson(
  CashiersResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'meta': instance.meta,
};
