// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftStatisticsModel _$ShiftStatisticsModelFromJson(
  Map<String, dynamic> json,
) => ShiftStatisticsModel(
  totalCashierShifts: (json['total_cashier_shifts'] as num?)?.toInt(),
  completedCashierShifts: (json['completed_cashier_shifts'] as num?)?.toInt(),
  pendingCashierShifts: (json['pending_cashier_shifts'] as num?)?.toInt(),
  completionRate: json['completion_rate'] as num,
);

Map<String, dynamic> _$ShiftStatisticsModelToJson(
  ShiftStatisticsModel instance,
) => <String, dynamic>{
  'total_cashier_shifts': instance.totalCashierShifts,
  'completed_cashier_shifts': instance.completedCashierShifts,
  'pending_cashier_shifts': instance.pendingCashierShifts,
  'completion_rate': instance.completionRate,
};
