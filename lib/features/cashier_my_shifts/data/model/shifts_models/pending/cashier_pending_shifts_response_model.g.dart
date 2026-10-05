// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_pending_shifts_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierPendingShiftsResponseModel _$CashierPendingShiftsResponseModelFromJson(
  Map<String, dynamic> json,
) => CashierPendingShiftsResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => CashierPendingShiftModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CashierPendingShiftsResponseModelToJson(
  CashierPendingShiftsResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'meta': instance.meta,
};
