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
      id: (json['id'] ?? '').toString(),
      shiftDate: (json['shift_date'] as String?) ?? '',
      shiftDateIso: (json['shift_date_iso'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      responsibilityStatus: ResponsibilityStatusX.fromJson(
        json['responsibility_status'],
      ),
      handOverFrom: (json['hand_over_from'] ?? 'N/A').toString(),
      handOverTo: json['hand_over_to']?.toString(),
      cashHandoverAmount: (json['cash_handover_amount'] as num?) ?? 0,
      varianceAmount: (json['variance_amount'] as num?) ?? 0,
      varianceType: (json['variance_type'] as String?) ?? 'None',
      reasonForVariance: json['reason_for_variance'] as String?,
      acceptanceMessage: json['acceptance_message'] as String?,
      responsibilityReviewedAt: json['responsibility_reviewed_at'] as String?,
    );
  }
}
