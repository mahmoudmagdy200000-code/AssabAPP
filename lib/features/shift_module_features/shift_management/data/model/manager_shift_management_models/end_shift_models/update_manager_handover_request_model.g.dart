// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_manager_handover_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateManagerHandoverRequestModel _$UpdateManagerHandoverRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateManagerHandoverRequestModel(
  managerWorkdayId: json['manager_workday_id'] as String,
  cashierBreakdown: (json['cashier_breakdown'] as List<dynamic>)
      .map(
        (e) => CashierBreakdownRequestModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$UpdateManagerHandoverRequestModelToJson(
  UpdateManagerHandoverRequestModel instance,
) => <String, dynamic>{
  'manager_workday_id': instance.managerWorkdayId,
  'cashier_breakdown': instance.cashierBreakdown
      .map((e) => e.toJson())
      .toList(),
};
