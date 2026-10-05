// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressStatisticsModel _$ProgressStatisticsModelFromJson(
  Map<String, dynamic> json,
) => ProgressStatisticsModel(
  totalShifts: (json['totalShifts'] as num?)?.toInt(),
  completedShifts: (json['completedShifts'] as num?)?.toInt(),
  pendingShifts: (json['pendingShifts'] as num?)?.toInt(),
);

Map<String, dynamic> _$ProgressStatisticsModelToJson(
  ProgressStatisticsModel instance,
) => <String, dynamic>{
  'totalShifts': instance.totalShifts,
  'completedShifts': instance.completedShifts,
  'pendingShifts': instance.pendingShifts,
};
