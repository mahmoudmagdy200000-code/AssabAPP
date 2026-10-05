// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftProgress _$ShiftProgressFromJson(Map<String, dynamic> json) =>
    ShiftProgress(
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      numberOfHours: (json['number_of_hours'] as num).toInt(),
      progressPercentage: (json['progress_percentage'] as num).toInt(),
    );

Map<String, dynamic> _$ShiftProgressToJson(ShiftProgress instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'number_of_hours': instance.numberOfHours,
      'progress_percentage': instance.progressPercentage,
    };
