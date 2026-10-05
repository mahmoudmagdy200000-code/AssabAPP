// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_actions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftActionsModel _$ShiftActionsModelFromJson(Map<String, dynamic> json) =>
    ShiftActionsModel(
      viewDetails: json['view_details'] as bool,
      startShift: json['start_shift'] as bool,
    );

Map<String, dynamic> _$ShiftActionsModelToJson(ShiftActionsModel instance) =>
    <String, dynamic>{
      'view_details': instance.viewDetails,
      'start_shift': instance.startShift,
    };
