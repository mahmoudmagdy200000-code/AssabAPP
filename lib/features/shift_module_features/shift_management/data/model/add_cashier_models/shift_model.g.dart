// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkShift _$WorkShiftFromJson(Map<String, dynamic> json) => WorkShift(
  name: json['name'] as String,
  timeFrom: json['timeFrom'] as String,
  timeTo: json['timeTo'] as String,
  isEnabled: json['isEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$WorkShiftToJson(WorkShift instance) => <String, dynamic>{
  'name': instance.name,
  'timeFrom': instance.timeFrom,
  'timeTo': instance.timeTo,
  'isEnabled': instance.isEnabled,
};

DayShifts _$DayShiftsFromJson(Map<String, dynamic> json) => DayShifts(
  day: json['day'] as String,
  shifts: (json['shifts'] as List<dynamic>)
      .map((e) => WorkShift.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DayShiftsToJson(DayShifts instance) => <String, dynamic>{
  'day': instance.day,
  'shifts': instance.shifts,
};
