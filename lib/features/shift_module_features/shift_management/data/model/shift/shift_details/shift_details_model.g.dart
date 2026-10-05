// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierExtendedModel _$CashierExtendedModelFromJson(
  Map<String, dynamic> json,
) => CashierExtendedModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$CashierExtendedModelToJson(
  CashierExtendedModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
};

HandoverApprovalModel _$HandoverApprovalModelFromJson(
  Map<String, dynamic> json,
) => HandoverApprovalModel(
  id: json['id'] as String,
  name: json['name'] as String,
  userType: UserType.fromJson(json['user_type'] as String?),
  action: json['action'] as String,
  reviewedAt: json['reviewed_at'] as String,
);

Map<String, dynamic> _$HandoverApprovalModelToJson(
  HandoverApprovalModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'user_type': _$UserTypeEnumMap[instance.userType]!,
  'action': instance.action,
  'reviewed_at': instance.reviewedAt,
};

const _$UserTypeEnumMap = {
  UserType.cashier: 'cashier',
  UserType.manager: 'manager',
};

HandoverDetailsModel _$HandoverDetailsModelFromJson(
  Map<String, dynamic> json,
) => HandoverDetailsModel(
  handoverFrom: json['handover_from'] as String?,
  handoverFromId: json['handover_from_id'] as String?,
  handoverTo: json['handover_to'] as String?,
  handoverToId: json['handover_to_id'] as String?,
  handoverToType: json['handover_to_type'] as String?,
  handoverDate: json['handover_date'] as String?,
  handoverTime: json['handover_time'] as String?,
  actionedBy: json['actioned_by'] == null
      ? null
      : AssignedByModel.fromJson(json['actioned_by'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HandoverDetailsModelToJson(
  HandoverDetailsModel instance,
) => <String, dynamic>{
  'handover_from': instance.handoverFrom,
  'handover_from_id': instance.handoverFromId,
  'handover_to': instance.handoverTo,
  'handover_to_id': instance.handoverToId,
  'handover_to_type': instance.handoverToType,
  'handover_date': instance.handoverDate,
  'handover_time': instance.handoverTime,
  'actioned_by': instance.actionedBy?.toJson(),
};

VarianceDetailsModel _$VarianceDetailsModelFromJson(
  Map<String, dynamic> json,
) => VarianceDetailsModel(
  responsibilityType: json['responsibility_type'] as String?,
  currentCashierAmount: JsonValueParser.toInt(json['current_cashier_amount']),
  totalVarianceAmount: JsonValueParser.toInt(json['total_variance_amount']),
  varianceType: json['variance_type'] as String?,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$VarianceDetailsModelToJson(
  VarianceDetailsModel instance,
) => <String, dynamic>{
  'responsibility_type': instance.responsibilityType,
  'current_cashier_amount': instance.currentCashierAmount,
  'total_variance_amount': instance.totalVarianceAmount,
  'variance_type': instance.varianceType,
  'reason': instance.reason,
};

SalesBreakDownModel _$SalesBreakDownModelFromJson(Map<String, dynamic> json) =>
    SalesBreakDownModel(
      id: json['id'] as String,
      aggregator: json['aggregator'] as String,
      amount: JsonValueParser.toInt(json['amount']),
    );

Map<String, dynamic> _$SalesBreakDownModelToJson(
  SalesBreakDownModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'aggregator': instance.aggregator,
  'amount': instance.amount,
};

HandoverToModel _$HandoverToModelFromJson(Map<String, dynamic> json) =>
    HandoverToModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$HandoverToModelToJson(HandoverToModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'email': instance.email,
    };

AssignedByModel _$AssignedByModelFromJson(Map<String, dynamic> json) =>
    AssignedByModel(
      id: json['id'] as String,
      name: json['name'] as String,
      userType: UserType.fromJson(json['user_type'] as String?),
    );

Map<String, dynamic> _$AssignedByModelToJson(AssignedByModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'user_type': _$UserTypeEnumMap[instance.userType]!,
    };
