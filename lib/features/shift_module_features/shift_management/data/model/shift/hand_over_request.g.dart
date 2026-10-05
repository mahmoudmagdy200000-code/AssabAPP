// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hand_over_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandOverRequest _$HandOverRequestFromJson(Map<String, dynamic> json) =>
    HandOverRequest(
      handoverType: json['handover_to_type'] as String,
      handOverAmount: (json['handover_amount'] as num).toDouble(),
      nextCashierId: json['next_cashier_id'] as String?,
      branchManagerId: json['branch_manager_id'] as String?,
      handoverNotes: json['handover_notes'] as String?,
    );

Map<String, dynamic> _$HandOverRequestToJson(HandOverRequest instance) =>
    <String, dynamic>{
      'handover_to_type': instance.handoverType,
      'next_cashier_id': instance.nextCashierId,
      'branch_manager_id': instance.branchManagerId,
      'handover_amount': instance.handOverAmount,
      'handover_notes': instance.handoverNotes,
    };
