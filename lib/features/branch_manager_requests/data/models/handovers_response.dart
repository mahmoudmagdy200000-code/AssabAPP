import 'package:assab/shared/models/meta_model/meta_model.dart';

import '../../../../core/enums/shift_status/shift_handover_status.dart';

class HandoversResponse {
  final List<HandoversResponseItem> data;
  final MetaModel meta;

  const HandoversResponse({required this.data, required this.meta});

  factory HandoversResponse.fromJson(Map<String, dynamic> json) {
    return HandoversResponse(
      data: (json['data'] as List)
          .map((e) => HandoversResponseItem.fromJson(e))
          .toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}

class HandoversResponseItem {
  final String id;
  final String shiftDate;
  final String shiftDateIso;
  final HandoverStatus status;
  final num cashGiven;
  final String variance;
  final num varianceAmount;
  final String cashFrom;
  final String? acceptanceMessage;
  final String? responsibilityReviewedAt;
  final bool? isIncoming;
  final bool? isOutgoing;
  final bool? canBeAccepted;

  const HandoversResponseItem({
    required this.id,
    required this.shiftDate,
    required this.shiftDateIso,
    required this.status,
    required this.cashGiven,
    required this.variance,
    required this.varianceAmount,
    required this.cashFrom,
    required this.acceptanceMessage,
    this.responsibilityReviewedAt,
    this.isIncoming,
    this.isOutgoing,
    this.canBeAccepted,
  });

  factory HandoversResponseItem.fromJson(Map<String, dynamic> json) {
    return HandoversResponseItem(
      id: json['id'],
      shiftDate: json['shift_date'],
      shiftDateIso: json['shift_date_iso'],
      status: handoverStatusFromJson(json['status']),
      cashGiven: json['cash_given'] is num ? (json['cash_given'] as num) : (num.tryParse(json['cash_given']?.toString() ?? '') ?? 0),
      responsibilityReviewedAt: json['responsibility_reviewed_at'],
      variance: json['variance'],
      varianceAmount: json['variance_amount'] is num ? (json['variance_amount'] as num) : (num.tryParse(json['variance_amount']?.toString() ?? '') ?? 0),
      cashFrom: json['cash_from'],
      acceptanceMessage: json['acceptance_message'],
      isIncoming: json['is_incoming'] as bool?,
      isOutgoing: json['is_outgoing'] as bool?,
      canBeAccepted: json['can_be_accepted'] as bool? ?? false,
    );
  }
}
