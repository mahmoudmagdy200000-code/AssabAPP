import 'package:assab/features/branch_manager_requests/domain/enums/responsibility_status.dart';

import '../../../../shared/models/meta_model/meta_model.dart';

class VariancesResponse {
  final List<VarianceItem> data;
  final MetaModel meta;

  const VariancesResponse({required this.data, required this.meta});

  factory VariancesResponse.fromJson(Map<String, dynamic> json) {
    return VariancesResponse(
      data: (json['data'] as List)
          .map((e) => VarianceItem.fromJson(e))
          .toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}

class VarianceItem {
  final String id;
  final String shiftDate;
  final String shiftDateIso;
  final String status;
  final String handOverFrom;
  final String? handOverTo;
  final num cashHandoverAmount;
  final num varianceAmount;
  final String varianceType;
  final ResponsibilityStatus responsibilityStatus;
  final String? reasonForVariance;
  final String? acceptanceMessage;
  final String? responsibilityReviewedAt;

  const VarianceItem({
    required this.id,
    required this.shiftDate,
    required this.shiftDateIso,
    required this.status,
    required this.handOverFrom,
    required this.responsibilityStatus,
    required this.handOverTo,
    required this.cashHandoverAmount,
    required this.varianceAmount,
    required this.varianceType,
    required this.reasonForVariance,
    required this.acceptanceMessage,
    required this.responsibilityReviewedAt,
  });

  factory VarianceItem.fromJson(Map<String, dynamic> json) {
    return VarianceItem(
      id: json['id'],
      shiftDate: json['shift_date'],
      shiftDateIso: json['shift_date_iso'],
      status: json['status'],
      responsibilityStatus: ResponsibilityStatusX.fromJson(
        json['responsibility_status'],
      ),
      handOverFrom: json['hand_over_from'],
      handOverTo: json['hand_over_to'],
      cashHandoverAmount: json['cash_handover_amount'],
      varianceAmount: json['variance_amount'],
      varianceType: json['variance_type'],
      reasonForVariance: json['reason_for_variance'],
      acceptanceMessage: json['acceptance_message'],
      responsibilityReviewedAt: json['responsibility_reviewed_at'],
    );
  }
}
