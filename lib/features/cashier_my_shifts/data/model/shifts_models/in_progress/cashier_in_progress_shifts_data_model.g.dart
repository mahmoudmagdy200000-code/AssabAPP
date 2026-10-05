// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_in_progress_shifts_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierInProgressShiftsDataModel _$CashierInProgressShiftsDataModelFromJson(
  Map<String, dynamic> json,
) => CashierInProgressShiftsDataModel(
  shifts: (json['shifts'] as List<dynamic>)
      .map(
        (e) => CashierInProgressShiftModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$CashierInProgressShiftsDataModelToJson(
  CashierInProgressShiftsDataModel instance,
) => <String, dynamic>{'shifts': instance.shifts, 'count': instance.count};
