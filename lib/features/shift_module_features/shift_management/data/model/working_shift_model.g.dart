// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'working_shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkingShiftModel _$WorkingShiftModelFromJson(Map<String, dynamic> json) =>
    WorkingShiftModel(
      id: json['id'] as String,
      name: json['name'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );

Map<String, dynamic> _$WorkingShiftModelToJson(WorkingShiftModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
    };
