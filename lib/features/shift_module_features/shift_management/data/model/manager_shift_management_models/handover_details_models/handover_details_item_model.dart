import 'package:json_annotation/json_annotation.dart';

import '../../../../../../../core/enums/shift_status/shift_handover_status.dart';
import '../variance_details.dart';

part 'handover_details_item_model.g.dart';

@JsonSerializable()
class HandoverDetailsItemModel {
  @JsonKey(name: 'handover_id')
  final String handoverId;

  @JsonKey(name: 'cashier_shift_id')
  final String cashierShiftId;

  @JsonKey(name: 'cashier_name')
  final String cashierName;

  @JsonKey(name: 'shift_time')
  final String shiftTime;

  @JsonKey(name: 'handover_amount')
  final double handoverAmount;

  @JsonKey(name: 'handover_date')
  final String handoverDate;

  @JsonKey(name: 'handover_time')
  final String handoverTime;

  @JsonKey(name: 'handover_notes')
  final String? handoverNotes;

  @JsonKey(name: 'handover_from')
  final String handoverFrom;

  @JsonKey(name: 'handover_to')
  final String handoverTo;

  @JsonKey(name: 'handover_to_id')
  final String handoverToId;

  @JsonKey(name: 'total_sales')
  final double totalSales;

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
  final String? approvedAt;

  @JsonKey(name: 'approved_by')
  final String? approvedBy;

  @JsonKey(name: 'can_approve')
  final bool canApprove;

  @JsonKey(name: 'can_reject')
  final bool canReject;

  @JsonKey(name: 'variance_details')
  final VarianceDetailsModel? varianceDetails;

  @JsonKey(name: 'accounting_name')
  final String accountingName;

  const HandoverDetailsItemModel({
    required this.handoverId,
    required this.cashierShiftId,
    required this.cashierName,
    required this.shiftTime,
    required this.handoverAmount,
    required this.handoverDate,
    required this.handoverTime,
    this.handoverNotes,
    required this.handoverFrom,
    required this.handoverTo,
    required this.handoverToId,
    required this.totalSales,
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
    required this.canApprove,
    required this.canReject,
    required this.varianceDetails,
    required this.accountingName,
  });

  factory HandoverDetailsItemModel.fromJson(Map<String, dynamic> json) =>
      _$HandoverDetailsItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$HandoverDetailsItemModelToJson(this);
}
