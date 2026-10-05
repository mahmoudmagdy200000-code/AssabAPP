import 'package:assab/core/enums/shift_status/shift_handover_status.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/cashier_handover_models/correction_details_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/variance_details.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cashier_handover_details_model.g.dart';

@JsonSerializable()
class CashierHandoverDetailsModel {
  final bool success;
  final String message;
  final CashierHandoverData data;

  CashierHandoverDetailsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CashierHandoverDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$CashierHandoverDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierHandoverDetailsModelToJson(this);
}

@JsonSerializable()
class CashierHandoverData {
  final CashierHandover handover;

  CashierHandoverData({required this.handover});

  factory CashierHandoverData.fromJson(Map<String, dynamic> json) =>
      _$CashierHandoverDataFromJson(json);

  Map<String, dynamic> toJson() => _$CashierHandoverDataToJson(this);
}

@JsonSerializable()
class CashierHandover {
  @JsonKey(name: 'handover_id')
  final String handoverId;

  @JsonKey(name: 'cashier_shift_id')
  final String cashierShiftId;

  @JsonKey(name: 'cashier_name')
  final String cashierName;

  @JsonKey(name: 'cashier_id')
  final String cashierId;

  @JsonKey(name: 'shift_time')
  final String shiftTime;

  @JsonKey(name: 'shift_id')
  final String shiftId;

  @JsonKey(name: 'handover_amount')
  final double handoverAmount;

  @JsonKey(name: 'total_sales')
  final double totalSales;

  @JsonKey(name: 'net_sales')
  final double netSales;

  @JsonKey(name: 'vat_amount')
  final double vatAmount;

  @JsonKey(name: 'cash_collected')
  final double cashCollected;

  @JsonKey(name: 'card_payments')
  final double cardPayments;

  @JsonKey(name: 'delivery_app_payments')
  final double deliveryAppPayments;

  @JsonKey(name: 'variance_amount')
  final double varianceAmount;

  @JsonKey(name: 'variance_type')
  final VarianceType varianceType;

  @JsonKey(name: 'variance_reason')
  final String? varianceReason;

  @JsonKey(name: 'attached_files')
  final List<String> attachedFiles;

  @JsonKey(fromJson: handoverStatusFromJson, toJson: handoverStatusToJson)
  final HandoverStatus status;

  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;

  @JsonKey(name: 'rejection_count')
  final int rejectionCount;

  @JsonKey(name: 'handed_over_at')
  final String? handedOverAt;

  @JsonKey(name: 'approved_at')
  final dynamic approvedAt;

  @JsonKey(name: 'approved_by')
  final String? approvedBy;

  @JsonKey(name: 'approved_by_id')
  final String? approvedById;

  @JsonKey(name: 'can_approve')
  final bool canApprove;

  @JsonKey(name: 'can_reject')
  final bool canReject;

  @JsonKey(name: 'variance_details')
  final VarianceDetailsModel? varianceDetails;

  @JsonKey(name: 'handover_to_type')
  final String handoverToType;

  @JsonKey(name: 'handover_to')
  final String handoverTo;

  @JsonKey(name: 'handover_to_id')
  final String handoverToId;

  @JsonKey(name: 'handover_date')
  final String handoverDate;

  @JsonKey(name: 'handover_time')
  final String handoverTime;

  @JsonKey(name: 'handover_notes')
  final String? handoverNotes;

  @JsonKey(name: 'correction_details')
  final CorrectionDetailsModel? correctionDetails;

  CashierHandover({
    required this.handoverId,
    required this.cashierShiftId,
    required this.cashierName,
    required this.cashierId,
    required this.shiftTime,
    required this.shiftId,
    required this.handoverAmount,
    required this.totalSales,
    required this.netSales,
    required this.vatAmount,
    required this.cashCollected,
    required this.cardPayments,
    required this.deliveryAppPayments,
    required this.varianceAmount,
    required this.varianceType,
    this.varianceReason,
    required this.attachedFiles,
    required this.status,
    this.rejectionReason,
    required this.rejectionCount,
    this.handedOverAt,
    this.approvedAt,
    this.approvedBy,
    this.approvedById,
    required this.canApprove,
    required this.canReject,
    required this.varianceDetails,
    required this.handoverToType,
    required this.handoverTo,
    required this.handoverToId,
    required this.handoverDate,
    required this.handoverTime,
    this.handoverNotes,
    this.correctionDetails,
  });

  factory CashierHandover.fromJson(Map<String, dynamic> json) =>
      _$CashierHandoverFromJson(json);

  Map<String, dynamic> toJson() => _$CashierHandoverToJson(this);
}
