// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_my_shift_actions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierPendingShiftActionsModel _$CashierPendingShiftActionsModelFromJson(
  Map<String, dynamic> json,
) => CashierPendingShiftActionsModel(
  viewDetails: json['view_details'] as bool? ?? false,
  reassignShift: json['reassign_shift'] as bool? ?? false,
);

Map<String, dynamic> _$CashierPendingShiftActionsModelToJson(
  CashierPendingShiftActionsModel instance,
) => <String, dynamic>{
  'view_details': instance.viewDetails,
  'reassign_shift': instance.reassignShift,
};
