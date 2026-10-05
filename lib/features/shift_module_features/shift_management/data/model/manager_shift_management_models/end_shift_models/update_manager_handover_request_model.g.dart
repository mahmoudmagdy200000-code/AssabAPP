// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_manager_handover_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateManagerHandoverRequestModel _$UpdateManagerHandoverRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateManagerHandoverRequestModel(
  cashierBreakdown: (json['cashier_breakdown'] as List<dynamic>)
      .map((e) => CashierBreakdownModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UpdateManagerHandoverRequestModelToJson(
  UpdateManagerHandoverRequestModel instance,
) => <String, dynamic>{
  'cashier_breakdown': instance.cashierBreakdown
      .map((e) => e.toJson())
      .toList(),
};
