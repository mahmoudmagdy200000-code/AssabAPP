import 'package:assab/core/utils/date_formatter.dart';

import '../../features/branch_manager_expenses/data/models/attachment_model.dart';

class DelayDetails {
  final String delayReason;
  final String newExpectedDeliveryDate;
  final String newExpectedDeliveryTime;
  final AttachmentModel? delayAttachment;
  final String delayReportedAt;
  final String delayApprovedAt;
  final String delayRejectedAt;
  final String branchManagerName;

  DelayDetails({
    required this.delayReason,
    required this.newExpectedDeliveryDate,
    required this.newExpectedDeliveryTime,
    this.delayAttachment,
    required this.delayReportedAt,
    required this.delayApprovedAt,
    required this.delayRejectedAt,
    required this.branchManagerName,
  });

  factory DelayDetails.fromJson(Map<String, dynamic> json) {
    return DelayDetails(
      delayReason: json['delay_reason'] as String,
      newExpectedDeliveryDate:
          DateFormatter.formatDateMDY(
            DateTime.tryParse(
              json['new_expected_delivery_date'] as String? ?? '',
            ),
          ) ??
          '',
      newExpectedDeliveryTime:
          json['new_expected_delivery_time'] as String? ?? '',
      delayAttachment: json['delay_attachment'] != null
          ? AttachmentModel.fromJson(
              json['delay_attachment'] as Map<String, dynamic>,
            )
          : null,
      delayReportedAt:
          '${DateFormatter.formatDateMDY(DateTime.tryParse(json['delay_reported_at'] as String? ?? ''))} / ${DateFormatter.formatTimeHM(DateTime.tryParse(json['delay_reported_at'] as String? ?? ''))}',
      delayApprovedAt:
          '${DateFormatter.formatDateMDY(DateTime.tryParse(json['delay_approved_at'] as String? ?? ''))} / ${DateFormatter.formatTimeHM(DateTime.tryParse(json['delay_approved_at'] as String? ?? ''))}',
      delayRejectedAt:
          '${DateFormatter.formatDateMDY(DateTime.tryParse(json['delay_rejected_at'] as String? ?? ''))} / ${DateFormatter.formatTimeHM(DateTime.tryParse(json['delay_rejected_at'] as String? ?? ''))}',
      branchManagerName:
          (json['branch_manager'] != null &&
              json['branch_manager']['name'] != null)
          ? json['branch_manager']['name'] as String
          : '',
    );
  }
}
