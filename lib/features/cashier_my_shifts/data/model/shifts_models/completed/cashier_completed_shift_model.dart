import 'package:json_annotation/json_annotation.dart';
import '../../../../../shift_module_features/shift_management/domain/enums/user_type.dart';
import '../../../../domain/enums/my_shifts_status.dart';
import '../cashier_handover_status_model.dart';
import '../cashier_shifts_user_model.dart';

part 'cashier_completed_shift_model.g.dart';

@JsonSerializable()
class CashierCompletedShiftModel {
  final String id;

  @JsonKey(name: 'shift_date')
  final String shiftDate;

  @JsonKey(name: 'shift_name')
  final String shiftName;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  final MyShiftStatusType status;

  @JsonKey(name: 'closing_balance')
  final int closingBalance;

  @JsonKey(name: 'total_sales')
  final int totalSales;

  final int variance;

  @JsonKey(name: 'variance_type')
  final String varianceType;

  @JsonKey(name: 'next_cashier')
  final CashierShiftUserModel? nextCashier;

  @JsonKey(name: 'assigned_to')
  final CashierShiftUserModel? assignedTo;

  @JsonKey(name: 'handover_status')
  final CashierHandoverStatusModel? handoverStatus;

  @JsonKey(name: 'handover_to')
  final CashierShiftUserModel? handoverTo;

  @JsonKey(name: 'handover_approved_or_rejected_by')
  final CashierHandoverApprovedOrRejectedByModel? handoverApprovedOrRejectedBy;

  @JsonKey(name: 'branch_name')
  final String branchName;

  @JsonKey(name: 'branch_id')
  final String branchId;

  const CashierCompletedShiftModel({
    required this.id,
    required this.shiftDate,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.closingBalance,
    required this.totalSales,
    required this.variance,
    required this.varianceType,
    this.nextCashier,
    required this.assignedTo,
    required this.handoverStatus,
    this.handoverTo,
    this.handoverApprovedOrRejectedBy,
    required this.branchName,
    required this.branchId,
  });

  factory CashierCompletedShiftModel.fromJson(Map<String, dynamic> json) =>
      _$CashierCompletedShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierCompletedShiftModelToJson(this);
}

@JsonSerializable()
class CashierHandoverApprovedOrRejectedByModel {
  final String id;
  final String name;

  @JsonKey(name: 'user_type', fromJson: UserType.fromJson)
  final UserType userType;

  final String action;

  CashierHandoverApprovedOrRejectedByModel({
    required this.id,
    required this.name,
    required this.userType,
    required this.action,
  });

  factory CashierHandoverApprovedOrRejectedByModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CashierHandoverApprovedOrRejectedByModelFromJson(json);
}
