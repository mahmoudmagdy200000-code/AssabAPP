import 'package:json_annotation/json_annotation.dart';
import '../../../../domain/enums/my_shifts_status.dart';
import 'cashier_reassign_user_model.dart';

part 'cashier_reassigned_shift_model.g.dart';

@JsonSerializable()
class CashierReassignedShiftModel {
  final String id;

  @JsonKey(name: 'shift_date')
  final String shiftDate;

  @JsonKey(name: 'shift_name')
  final String shiftName;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  @JsonKey(name: 'reassigned_at')
  final String reassignedAt;

  @JsonKey(name: 'reassignment_reason')
  final String reassignmentReason;

  @JsonKey(name: 'closing_balance')
  final int closingBalance;

  final int variance;

  @JsonKey(name: 'cash_given')
  final int cashGiven;

  @JsonKey(name: 'reassigned_to')
  final CashierReassignUserModel reassignedTo;

  @JsonKey(name: 'reassigned_from')
  final CashierReassignUserModel reassignedFrom;

  @JsonKey(name: 'reassigned_by')
  final CashierReassignUserModel reassignedBy;

  @JsonKey(name: 'next_cashier')
  final String? nextCashier;

  @JsonKey(name: 'is_mid_reassign')
  final bool isMidReassign;

  @JsonKey(name: 'can_be_accepted')
  final bool canBeAccepted;

  @JsonKey(name: 'original_cashier')
  final String originalCashier;

  @JsonKey(name: 'branch_name')
  final String branchName;

  @JsonKey(name: 'branch_id')
  final String branchId;

  final MyShiftStatusType status;

  const CashierReassignedShiftModel({
    required this.id,
    required this.shiftDate,
    required this.shiftName,
    required this.reassignedAt,
    required this.reassignmentReason,
    required this.closingBalance,
    required this.variance,
    required this.cashGiven,
    required this.reassignedTo,
    required this.reassignedFrom,
    required this.reassignedBy,
    required this.startTime,
    required this.endTime,
    this.nextCashier,
    required this.isMidReassign,
    required this.canBeAccepted,
    required this.originalCashier,
    required this.branchName,
    required this.branchId,
    required this.status,
  });

  factory CashierReassignedShiftModel.fromJson(Map<String, dynamic> json) =>
      _$CashierReassignedShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierReassignedShiftModelToJson(this);
}
