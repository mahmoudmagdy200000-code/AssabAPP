import 'package:json_annotation/json_annotation.dart';
import '../../../../domain/enums/my_shifts_status.dart';
import '../../../converters/opening_balance_converter.dart';
import '../cashier_my_shift_actions_model.dart';
import '../cashier_shifts_user_model.dart';

part 'cashier_pending_shift_model.g.dart';

@JsonSerializable()
class CashierPendingShiftModel {
  final String id;
  final String date;
  final MyShiftStatusType status;

  @JsonKey(name: 'status_label')
  final String statusLabel;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  @JsonKey(name: 'opening_balance', fromJson: openingBalanceFromJson)
  final double? openingBalance;

  @JsonKey(name: 'cash_given')
  final int cashGiven;

  final int variance;

  @JsonKey(name: 'cash_from')
  final CashierShiftUserModel? cashFrom;

  @JsonKey(name: 'handover_to')
  final CashierShiftUserModel? handoverTo;

  @JsonKey(name: 'assigned_to')
  final String assignedTo;

  @JsonKey(name: 'next_cashier')
  final String? nextCashier;

  @JsonKey(name: 'assigned_by')
  final String assignedBy;

  @JsonKey(name: 'assigned_by_user_type')
  final String assignedByUserType;

  @JsonKey(name: 'is_next_shift')
  final bool isNextShift;

  @JsonKey(name: 'can_start')
  final bool canStart;

  @JsonKey(name: 'start_disabled_reason')
  final String? startDisabledReason;

  @JsonKey(name: 'start_disabled_code')
  final String? startDisabledCode;

  @JsonKey(name: 'window_phase')
  final String? windowPhase;

  @JsonKey(name: 'can_start_normal')
  final bool? canStartNormal;

  @JsonKey(name: 'can_start_late')
  final bool? canStartLate;

  @JsonKey(name: 'is_late_start')
  final bool? isLateStart;

  @JsonKey(name: 'requires_manager_authorization')
  final bool? requiresManagerAuthorization;

  final CashierPendingShiftActionsModel actions;

  const CashierPendingShiftModel({
    required this.id,
    required this.date,
    required this.status,
    required this.statusLabel,
    required this.startTime,
    required this.endTime,
    required this.openingBalance,
    required this.cashGiven,
    required this.variance,
    this.cashFrom,
    this.handoverTo,
    required this.assignedTo,
    this.nextCashier,
    required this.assignedBy,
    required this.assignedByUserType,
    required this.isNextShift,
    required this.canStart,
    this.startDisabledReason,
    this.startDisabledCode,
    this.windowPhase,
    this.canStartNormal,
    this.canStartLate,
    this.isLateStart,
    this.requiresManagerAuthorization,
    required this.actions,
  });

  factory CashierPendingShiftModel.fromJson(Map<String, dynamic> json) =>
      _$CashierPendingShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierPendingShiftModelToJson(this);
}
