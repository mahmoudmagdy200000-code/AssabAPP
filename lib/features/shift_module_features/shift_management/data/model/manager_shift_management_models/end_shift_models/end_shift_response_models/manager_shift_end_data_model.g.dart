// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_shift_end_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerShiftEndDataModel _$ManagerShiftEndDataModelFromJson(
  Map<String, dynamic> json,
) => ManagerShiftEndDataModel(
  finalHandover: json['final_handover'] == null
      ? null
      : EndShiftFinalHandoverModel.fromJson(
          json['final_handover'] as Map<String, dynamic>,
        ),
  dailyTotals: json['daily_totals'] == null
      ? null
      : DailyTotalsModel.fromJson(json['daily_totals'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ManagerShiftEndDataModelToJson(
  ManagerShiftEndDataModel instance,
) => <String, dynamic>{
  'final_handover': instance.finalHandover,
  'daily_totals': instance.dailyTotals,
};
