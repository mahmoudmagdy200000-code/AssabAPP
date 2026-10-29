import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/reassign_shift/reassignment_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shift_details/shift_info_details_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../cashier_model.dart';
import 'json_value_parser.dart';

class ShiftModel {
  final String id;
  final String shiftDate;
  final ShiftStatusType status;
  final CashierModel cashier;

  final ShiftInfoDetailsModel shift;

  final double? openingBalance;

  final double? closingBalance;

  final double? expectedBalance;

  final double? totalSales;

  final double? netSales;

  final double? vatAmount;

  final double? cashCollected;

  final double? cardPayments;

  final double? variance;
  final String? posReceipt;
  final String? actualStartTime;
  final String? actualEndTime;
  final String? handedOverAt;
  final String? handoverNotes;

  @JsonKey(name: 'next_cashier')
  final CashierModel? nextCashier;
  final ReassignmentModel? reassignment;

  ShiftModel({
    required this.id,
    required this.shiftDate,
    required this.status,
    required this.cashier,
    required this.shift,
    required this.openingBalance,
    required this.closingBalance,
    required this.expectedBalance,
    required this.totalSales,
    required this.netSales,
    required this.vatAmount,
    required this.cashCollected,
    required this.cardPayments,
    this.variance,
    this.posReceipt,
    this.actualStartTime,
    this.actualEndTime,
    this.handedOverAt,
    this.handoverNotes,
    this.nextCashier,
    this.reassignment,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] as String,
      shiftDate: json['shift_date'] as String,
      status: ShiftStatusType.fromString(json['status'] as String),
      cashier: CashierModel.fromJson(json['cashier'] as Map<String, dynamic>),
      shift: ShiftInfoDetailsModel.fromJson(
        json['shift'] as Map<String, dynamic>,
      ),
      openingBalance: JsonValueParser.toDouble(json['opening_balance']),
      closingBalance: JsonValueParser.toDouble(json['closing_balance']),
      expectedBalance: JsonValueParser.toDouble(json['expected_balance']),
      totalSales: JsonValueParser.toDouble(json['total_sales']),
      netSales: JsonValueParser.toDouble(json['net_sales']),
      vatAmount: JsonValueParser.toDouble(json['vat_amount']),
      cashCollected: JsonValueParser.toDouble(json['cash_collected']),
      cardPayments: JsonValueParser.toDouble(json['card_payments']),
      variance: JsonValueParser.toDouble(json['variance']),
      posReceipt: json['pos_receipt'] as String?,
      actualStartTime: json['actual_start_time'] as String?,
      actualEndTime: json['actual_end_time'] as String?,
      handedOverAt: json['handed_over_at'] as String?,
      handoverNotes: json['handover_notes'] as String?,
      nextCashier: json['next_cashier'] == null
          ? null
          : CashierModel.fromJson(json['next_cashier'] as Map<String, dynamic>),
      reassignment: json['reassignment'] == null
          ? null
          : ReassignmentModel.fromJson(
              json['reassignment'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shift_date': shiftDate,
      'status': status.toString(),
      'cashier': cashier.toJson(),
      'shift': shift.toJson(),
      'opening_balance': openingBalance,
      'closing_balance': closingBalance,
      'expected_balance': expectedBalance,
      'total_sales': totalSales,
      'net_sales': netSales,
      'vat_amount': vatAmount,
      'cash_collected': cashCollected,
      'card_payments': cardPayments,
      'variance': variance,
      'pos_receipt': posReceipt,
      'actual_start_time': actualStartTime,
      'actual_end_time': actualEndTime,
      'handed_over_at': handedOverAt,
      'handover_notes': handoverNotes,
      'next_cashier': nextCashier?.toJson(),
      'reassignment': reassignment?.toJson(),
    };
  }
}
