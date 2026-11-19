import 'package:json_annotation/json_annotation.dart';

part 'cashier_breakdown_model.g.dart';

@JsonSerializable()
class CashierBreakdownModel {
  @JsonKey(name: 'cashier_id')
  final String cashierId;

  @JsonKey(name: 'cashier_shift_id')
  final String? cashierShiftId;

  @JsonKey(name: 'expected_revision')
  final int? expectedRevision;

  @JsonKey(name: 'cashier_name')
  final String cashierName;

  @JsonKey(name: 'cash_collected')
  final double? cashCollected;

  @JsonKey(name: 'card_payments')
  final double? cardPayments;

  @JsonKey(name: 'delivery_app_payments')
  final double? deliveryAppPayments;

  /// Server-derived financial balance indicator. Strictly read-only; never serialized to write payloads.
  @JsonKey(name: 'variance', includeToJson: false)
  final double? variance;

  @JsonKey(name: 'sales')
  final double? sales;

  /// Read-only liability approval metadata from backend canonical daily close summary.
  @JsonKey(name: 'liability_approval_status', includeToJson: false)
  final String? liabilityApprovalStatus;

  @JsonKey(name: 'liability_allocation_version', includeToJson: false)
  final int? liabilityAllocationVersion;

  @JsonKey(name: 'liability_has_manager_self_share', includeToJson: false)
  final bool? liabilityHasManagerSelfShare;

  const CashierBreakdownModel({
    required this.cashierId,
    this.cashierShiftId,
    this.expectedRevision,
    required this.cashierName,
    this.cashCollected,
    this.cardPayments,
    this.deliveryAppPayments,
    this.variance,
    this.sales,
    this.liabilityApprovalStatus,
    this.liabilityAllocationVersion,
    this.liabilityHasManagerSelfShare,
  });

  factory CashierBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$CashierBreakdownModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierBreakdownModelToJson(this);
}