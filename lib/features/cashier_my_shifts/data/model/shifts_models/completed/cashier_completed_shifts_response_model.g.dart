// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_completed_shifts_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierCompletedShiftsResponseModel
_$CashierCompletedShiftsResponseModelFromJson(Map<String, dynamic> json) =>
    CashierCompletedShiftsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map(
            (e) =>
                CashierCompletedShiftModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CashierCompletedShiftsResponseModelToJson(
  CashierCompletedShiftsResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'meta': instance.meta,
};
