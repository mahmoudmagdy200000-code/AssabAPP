import 'package:assab/features/shift_module_features/shift_management/domain/enums/user_type.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../domain/enums/my_shifts_status.dart';
import '../../../converters/opening_balance_converter.dart';

part 'cashier_in_progress_shift_model.g.dart';

@JsonSerializable()
class CashierInProgressShiftModel {
  final String id;
  final String date;

  final MyShiftStatusType status;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  @JsonKey(name: 'actual_start_time')
  final String? actualStartTime;

  @JsonKey(name: 'opening_balance', fromJson: openingBalanceFromJson)
  final int? openingBalance;

  @JsonKey(name: 'closing_balance')
  final int closingBalance;

  @JsonKey(name: 'assigned_to')
  final String assignedTo;

  @JsonKey(name: 'next_cashier')
  final String? nextCashier;

  @JsonKey(name: 'assigned_by')
  final String assignedBy;

  @JsonKey(name: 'assigned_by_user_type', fromJson: UserType.fromJson)
  final UserType assignedByUserType;

  const CashierInProgressShiftModel({
    required this.id,
    required this.date,
    required this.status,
    required this.startTime,
    required this.endTime,
    this.actualStartTime,
    required this.openingBalance,
    required this.closingBalance,
    required this.assignedTo,
    this.nextCashier,
    required this.assignedBy,
    required this.assignedByUserType,
  });

  factory CashierInProgressShiftModel.fromJson(Map<String, dynamic> json) =>
      _$CashierInProgressShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierInProgressShiftModelToJson(this);
}
