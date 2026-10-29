import 'package:assab/features/shift_module_features/shift_management/data/model/shift/reassign_shift/reassignment_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../../core/enums/shift_status/shift_status_type.dart';
import '../../../../domain/enums/user_type.dart';
import '../../cashier_model.dart';
import '../json_value_parser.dart';
import 'handover_status_model.dart';
import 'shift_info_details_model.dart';

part 'shift_details_model.g.dart';

// @JsonSerializable(explicitToJson: true)
// class ShiftDetailsModel {
//   final String id;
//   @JsonKey(name: 'shift_date')
//   final String shiftDate;
//   final ShiftStatusType status;
//   final CashierModel cashier;
//
//   @JsonKey(name: 'shift')
//   final ShiftInfoDetailsModel shiftInfoDetails;
//
//   @JsonKey(name: 'opening_balance')
//   final String openingBalance;
//   @JsonKey(name: 'closing_balance')
//   final double? closingBalance;
//   @JsonKey(name: 'expected_balance')
//   final String expectedBalance;
//   final double? variance;
//   @JsonKey(name: 'total_sales')
//   final String totalSales;
//   @JsonKey(name: 'net_sales')
//   final String netSales;
//   @JsonKey(name: 'vat_amount')
//   final String vatAmount;
//   @JsonKey(name: 'cash_collected')
//   final String cashCollected;
//   @JsonKey(name: 'card_payments')
//   final String cardPayments;
//
//   @JsonKey(name: 'assigned_by')
//   final AssignedByModel? assignedBy;
//
//   @JsonKey(name: 'pos_receipt')
//   final String? posReceipt;
//   @JsonKey(name: 'actual_start_time')
//   final String? actualStartTime;
//   @JsonKey(name: 'actual_end_time')
//   final String? actualEndTime;
//   @JsonKey(name: 'handed_over_at')
//   final String? handedOverAt;
//   @JsonKey(name: 'handover_notes')
//   final String? handoverNotes;
//   @JsonKey(name: 'handover_amount')
//   final double? handoverAmount;
//
//   @JsonKey(name: 'handover_to')
//   final HandoverToModel? handoverTo;
//
//   @JsonKey(name: 'handover_status')
//   final HandoverStatusModel? handoverStatus;
//   @JsonKey(name: 'next_cashier')
//   final CashierModel? nextCashier;
//   // @JsonKey(name: 'variance')
//
//   @JsonKey(name: 'sales_breakdown')
//   final List<SalesBreakDownModel>? aggregators;
//
//   @JsonKey(name: 'reassignment')
//   final ReassignmentModel? reassignment;
//
//   ShiftDetailsModel({
//     required this.id,
//     required this.shiftDate,
//     required this.status,
//     required this.cashier,
//     required this.shiftInfoDetails,
//     required this.openingBalance,
//     required this.closingBalance,
//     required this.expectedBalance,
//     required this.variance,
//     required this.totalSales,
//     required this.netSales,
//     required this.vatAmount,
//     required this.cashCollected,
//     required this.cardPayments,
//     this.handoverTo,
//     this.posReceipt,
//     this.actualStartTime,
//     this.actualEndTime,
//     this.handedOverAt,
//     this.handoverNotes,
//     this.handoverAmount,
//     this.handoverStatus,
//     this.nextCashier,
//     this.aggregators,
//     this.reassignment,
//     this.assignedBy
//   });
//
//   factory ShiftDetailsModel.fromJson(Map<String, dynamic> json) =>
//       _$ShiftDetailsModelFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ShiftDetailsModelToJson(this);
// }

class ShiftDetailsModel {
  final String id;

  final String shiftDate;

  final ShiftStatusType status;
  final CashierModel cashier;

  final ShiftInfoDetailsModel shiftInfoDetails;

  final double? openingBalance;

  final double? closingBalance;

  final double? expectedBalance;

  final double? variance;

  final int? totalSales;

  final int? netSales;

  final int? vatAmount;

  final int? cashCollected;

  final int? cardPayments;

  final String? posReceipt;

  final String? actualStartTime;

  final String? actualEndTime;

  final String? handedOverAt;

  final String? handoverNotes;

  final double? handoverAmount;

  final HandoverStatusModel? handoverStatus;

  final HandoverDetailsModel? handoverDetails;

  final HandoverToModel? handoverTo;

  final HandoverApprovalModel? handoverApprovedOrRejectedBy;

  final CashierModel? assignedTo;

  final AssignedByModel? cashFrom;

  final CashierModel? nextCashier;

  final List<SalesBreakDownModel>? aggregators;

  final VarianceDetailsModel? varianceDetails;

  final ReassignmentModel? reassignment;

  final bool? isMidReassign;

  final bool? canBeAccepted;

  final bool? isShiftReassignedToMe;

  final double? cashGiven;

  final String? previousCashier;

  final String? reassignReason;

  final String? varianceReason;

  ShiftDetailsModel({
    required this.id,
    required this.shiftDate,
    required this.status,
    required this.cashier,
    required this.shiftInfoDetails,
    required this.openingBalance,
    required this.closingBalance,
    required this.expectedBalance,
    required this.variance,
    required this.totalSales,
    required this.netSales,
    required this.vatAmount,
    required this.cashCollected,
    required this.cardPayments,
    this.posReceipt,
    this.actualStartTime,
    this.actualEndTime,
    this.handedOverAt,
    this.handoverNotes,
    this.handoverAmount,
    this.handoverStatus,
    this.handoverDetails,
    this.handoverTo,
    this.handoverApprovedOrRejectedBy,
    this.assignedTo,
    this.cashFrom,
    this.nextCashier,
    this.aggregators,
    this.varianceDetails,
    this.reassignment,
    this.isMidReassign,
    this.canBeAccepted,
    this.isShiftReassignedToMe,
    this.cashGiven,
    this.previousCashier,
    this.reassignReason,
    this.varianceReason,
  });

  factory ShiftDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) => ShiftDetailsModel(
    id: json['id'] as String,
    shiftDate: json['shift_date'] as String,
    status: ShiftStatusType.fromString(json['status'] as String),
    cashier: CashierModel.fromJson(json['cashier'] as Map<String, dynamic>),
    shiftInfoDetails: ShiftInfoDetailsModel.fromJson(
      json['shift'] as Map<String, dynamic>,
    ),
    openingBalance: JsonValueParser.toDouble(json['opening_balance']),
    closingBalance: JsonValueParser.toDouble(json['closing_balance']),
    expectedBalance: JsonValueParser.toDouble(json['expected_balance']),
    variance: JsonValueParser.toDouble(json['variance']),
    totalSales: JsonValueParser.toInt(json['total_sales']),
    netSales: JsonValueParser.toInt(json['net_sales']),
    vatAmount: JsonValueParser.toInt(json['vat_amount']),
    cashCollected: JsonValueParser.toInt(json['cash_collected']),
    cardPayments: JsonValueParser.toInt(json['card_payments']),
    posReceipt: json['pos_receipt'] as String?,
    actualStartTime: json['actual_start_time'] as String?,
    actualEndTime: json['actual_end_time'] as String?,
    handedOverAt: json['handed_over_at'] as String?,
    handoverNotes: json['handover_notes'] as String?,
    handoverAmount: JsonValueParser.toDouble(json['handover_amount']),
    handoverStatus: json['handover_status'] == null
        ? null
        : HandoverStatusModel.fromJson(
            json['handover_status'] as Map<String, dynamic>,
          ),
    handoverDetails: json['handover_details'] == null
        ? null
        : HandoverDetailsModel.fromJson(
            json['handover_details'] as Map<String, dynamic>,
          ),
    handoverTo: json['handover_to'] == null
        ? null
        : HandoverToModel.fromJson(json['handover_to'] as Map<String, dynamic>),
    handoverApprovedOrRejectedBy:
        json['handover_approved_or_rejected_by'] == null
        ? null
        : HandoverApprovalModel.fromJson(
            json['handover_approved_or_rejected_by'] as Map<String, dynamic>,
          ),
    assignedTo: json['assigned_to'] == null
        ? null
        : CashierModel.fromJson(json['assigned_to'] as Map<String, dynamic>),
    cashFrom: json['cash_from'] == null
        ? null
        : AssignedByModel.fromJson(json['cash_from'] as Map<String, dynamic>),
    nextCashier: json['next_cashier'] == null
        ? null
        : CashierModel.fromJson(json['next_cashier'] as Map<String, dynamic>),
    aggregators: (json['sales_breakdown'] as List<dynamic>?)
        ?.map((e) => SalesBreakDownModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    varianceDetails: json['variance_details'] == null
        ? null
        : VarianceDetailsModel.fromJson(
            json['variance_details'] as Map<String, dynamic>,
          ),
    reassignment: json['reassignment'] == null
        ? null
        : ReassignmentModel.fromJson(
            json['reassignment'] as Map<String, dynamic>,
          ),
    isMidReassign: json['is_mid_reassign'] as bool?,
    canBeAccepted: json['can_be_accepted'] as bool?,
    isShiftReassignedToMe: json['is_shift_reassigned_to_me'] as bool?,
    cashGiven: JsonValueParser.toDouble(json['cash_given']),
    previousCashier: json['previous_cashier'] as String?,
    reassignReason: json['reassign_reason'] as String?,
    varianceReason: json['variance_reason'] as String?,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shift_date': shiftDate,
      'status': status.value,
      'cashier': cashier.toJson(),
      'shift': shiftInfoDetails.toJson(),
      'opening_balance': openingBalance,
      'closing_balance': closingBalance,
      'expected_balance': expectedBalance,
      'variance': variance,
      'total_sales': totalSales,
      'net_sales': netSales,
      'vat_amount': vatAmount,
      'cash_collected': cashCollected,
      'card_payments': cardPayments,
      'pos_receipt': posReceipt,
      'actual_start_time': actualStartTime,
      'actual_end_time': actualEndTime,
      'handed_over_at': handedOverAt,
      'handover_notes': handoverNotes,
      'handover_amount': handoverAmount,
      'handover_status': handoverStatus?.toJson(),
      'handover_details': handoverDetails?.toJson(),
      'handover_to': handoverTo?.toJson(),
      'handover_approved_or_rejected_by': handoverApprovedOrRejectedBy
          ?.toJson(),
      'assigned_to': assignedTo?.toJson(),
      'cash_from': cashFrom?.toJson(),
      'next_cashier': nextCashier?.toJson(),
      'sales_breakdown': aggregators?.map((e) => e.toJson()).toList(),
      'variance_details': varianceDetails?.toJson(),
      'reassignment': reassignment?.toJson(),
      'is_mid_reassign': isMidReassign,
      'can_be_accepted': canBeAccepted,
      'is_shift_reassigned_to_me': isShiftReassignedToMe,
      'cash_given': cashGiven,
      'previous_cashier': previousCashier,
      'reassign_reason': reassignReason,
      'variance_reason': varianceReason,
    };
  }
}

@JsonSerializable()
class CashierExtendedModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;

  CashierExtendedModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
  });

  factory CashierExtendedModel.fromJson(Map<String, dynamic> json) =>
      _$CashierExtendedModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierExtendedModelToJson(this);
}

@JsonSerializable()
class HandoverApprovalModel {
  final String id;
  final String name;

  @JsonKey(name: 'user_type', fromJson: UserType.fromJson)
  final UserType userType;

  final String action;

  @JsonKey(name: 'reviewed_at')
  final String reviewedAt;

  HandoverApprovalModel({
    required this.id,
    required this.name,
    required this.userType,
    required this.action,
    required this.reviewedAt,
  });

  factory HandoverApprovalModel.fromJson(Map<String, dynamic> json) =>
      _$HandoverApprovalModelFromJson(json);

  Map<String, dynamic> toJson() => _$HandoverApprovalModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class HandoverDetailsModel {
  @JsonKey(name: 'handover_from')
  final String? handoverFrom;

  @JsonKey(name: 'handover_from_id')
  final String? handoverFromId;

  @JsonKey(name: 'handover_to')
  final String? handoverTo;

  @JsonKey(name: 'handover_to_id')
  final String? handoverToId;

  @JsonKey(name: 'handover_to_type')
  final String? handoverToType;

  @JsonKey(name: 'handover_date')
  final String? handoverDate;

  @JsonKey(name: 'handover_time')
  final String? handoverTime;

  @JsonKey(name: 'actioned_by')
  final AssignedByModel? actionedBy;

  HandoverDetailsModel({
    this.handoverFrom,
    this.handoverFromId,
    this.handoverTo,
    this.handoverToId,
    this.handoverToType,
    this.handoverDate,
    this.handoverTime,
    this.actionedBy,
  });

  factory HandoverDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$HandoverDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$HandoverDetailsModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VarianceDetailsModel {
  @JsonKey(name: 'responsibility_type')
  final String? responsibilityType;

  @JsonKey(name: 'current_cashier_amount', fromJson: JsonValueParser.toInt)
  final int? currentCashierAmount;

  @JsonKey(name: 'total_variance_amount', fromJson: JsonValueParser.toInt)
  final int? totalVarianceAmount;

  @JsonKey(name: 'variance_type')
  final String? varianceType;

  final String? reason;

  VarianceDetailsModel({
    this.responsibilityType,
    this.currentCashierAmount,
    this.totalVarianceAmount,
    this.varianceType,
    this.reason,
  });

  factory VarianceDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$VarianceDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$VarianceDetailsModelToJson(this);
}

@JsonSerializable()
class SalesBreakDownModel {
  final String id;
  final String aggregator;
  @JsonKey(name: 'amount', fromJson: JsonValueParser.toInt)
  final int? amount;

  const SalesBreakDownModel({
    required this.id,
    required this.aggregator,
    required this.amount,
  });

  factory SalesBreakDownModel.fromJson(Map<String, dynamic> json) =>
      _$SalesBreakDownModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesBreakDownModelToJson(this);
}

@JsonSerializable()
class HandoverToModel {
  final String id;
  final String name;
  final String type;
  final String email;

  const HandoverToModel({
    required this.id,
    required this.name,
    required this.type,
    required this.email,
  });

  factory HandoverToModel.fromJson(Map<String, dynamic> json) =>
      _$HandoverToModelFromJson(json);

  Map<String, dynamic> toJson() => _$HandoverToModelToJson(this);
}

@JsonSerializable()
class AssignedByModel {
  final String id;
  final String name;

  @JsonKey(name: 'user_type', fromJson: UserType.fromJson)
  final UserType userType;

  const AssignedByModel({
    required this.id,
    required this.name,
    required this.userType,
  });

  factory AssignedByModel.fromJson(Map<String, dynamic> json) =>
      _$AssignedByModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssignedByModelToJson(this);
}
