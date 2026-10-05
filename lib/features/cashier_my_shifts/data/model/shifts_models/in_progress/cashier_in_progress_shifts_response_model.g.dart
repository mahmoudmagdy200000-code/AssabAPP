// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_in_progress_shifts_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierInProgressShiftsResponseModel
_$CashierInProgressShiftsResponseModelFromJson(Map<String, dynamic> json) =>
    CashierInProgressShiftsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: CashierInProgressShiftsDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CashierInProgressShiftsResponseModelToJson(
  CashierInProgressShiftsResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
