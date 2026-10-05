import 'package:json_annotation/json_annotation.dart';
import '../../../../domain/enums/my_shifts_status.dart';
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

  @JsonKey(name: 'opening_balance')
  final int openingBalance;

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
  final String nextCashier;

  @JsonKey(name: 'assigned_by')
  final String assignedBy;

  @JsonKey(name: 'assigned_by_user_type')
  final String assignedByUserType;

  @JsonKey(name: 'is_next_shift')
  final bool isNextShift;

  @JsonKey(name: 'can_start')
  final bool canStart;

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
    required this.nextCashier,
    required this.assignedBy,
    required this.assignedByUserType,
    required this.isNextShift,
    required this.canStart,
    required this.actions,
  });

  factory CashierPendingShiftModel.fromJson(Map<String, dynamic> json) =>
      _$CashierPendingShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierPendingShiftModelToJson(this);
}
