// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_shift_breakdown_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierShiftBreakdownModel _$CashierShiftBreakdownModelFromJson(
  Map<String, dynamic> json,
) => CashierShiftBreakdownModel(
  byStatus: CashierShiftStatusBreakdownModel.fromJson(
    json['by_status'] as Map<String, dynamic>,
  ),
  byCashier: json['by_cashier'] as List<dynamic>,
  handoverStatus: HandoverStatusBreakdownModel.fromJson(
    json['handover_status'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CashierShiftBreakdownModelToJson(
  CashierShiftBreakdownModel instance,
) => <String, dynamic>{
  'by_status': instance.byStatus,
  'by_cashier': instance.byCashier,
  'handover_status': instance.handoverStatus,
};

CashierShiftStatusBreakdownModel _$CashierShiftStatusBreakdownModelFromJson(
  Map<String, dynamic> json,
) => CashierShiftStatusBreakdownModel(
  notStarted: (json['not_started'] as num).toInt(),
  inProgress: (json['in_progress'] as num).toInt(),
  completed: (json['completed'] as num).toInt(),
  reassigned: (json['reassigned'] as num).toInt(),
);

Map<String, dynamic> _$CashierShiftStatusBreakdownModelToJson(
  CashierShiftStatusBreakdownModel instance,
) => <String, dynamic>{
  'not_started': instance.notStarted,
  'in_progress': instance.inProgress,
  'completed': instance.completed,
  'reassigned': instance.reassigned,
};

HandoverStatusBreakdownModel _$HandoverStatusBreakdownModelFromJson(
  Map<String, dynamic> json,
) => HandoverStatusBreakdownModel(
  pending: (json['pending'] as num).toInt(),
  approved: (json['approved'] as num).toInt(),
  rejected: (json['rejected'] as num).toInt(),
);

Map<String, dynamic> _$HandoverStatusBreakdownModelToJson(
  HandoverStatusBreakdownModel instance,
) => <String, dynamic>{
  'pending': instance.pending,
  'approved': instance.approved,
  'rejected': instance.rejected,
};
