// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_reassigned_shifts_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierReassignedShiftsResponseModel
_$CashierReassignedShiftsResponseModelFromJson(Map<String, dynamic> json) =>
    CashierReassignedShiftsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map(
            (e) =>
                CashierReassignedShiftModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CashierReassignedShiftsResponseModelToJson(
  CashierReassignedShiftsResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'meta': instance.meta,
};
