// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftResponseModel _$ShiftResponseModelFromJson(Map<String, dynamic> json) =>
    ShiftResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => ShiftModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShiftResponseModelToJson(ShiftResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data.map((e) => e.toJson()).toList(),
      'meta': instance.meta.toJson(),
    };
