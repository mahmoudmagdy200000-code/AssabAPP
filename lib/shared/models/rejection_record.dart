import '../../core/enums/cancel_reason_user_type_enum.dart';

/// A review rejection, kept distinct from an authorized financial cancellation.
class RejectionRecord {
  final String reason;
  final String rejectedAt;
  final RejectionActor rejectedBy;

  const RejectionRecord({
    required this.reason,
    required this.rejectedAt,
    required this.rejectedBy,
  });

  factory RejectionRecord.fromJson(Map<String, dynamic> json) {
    return RejectionRecord(
      reason: json['reason'] as String? ?? '-',
      rejectedAt: json['rejected_at'] as String? ?? '',
      rejectedBy: RejectionActor.fromJson(
        json['rejected_by'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  /// Reads the new contract first and falls back only for older API servers.
  static RejectionRecord? fromEnvelope(Map<String, dynamic> json) {
    final canonical = json['rejection'];
    if (canonical is Map<String, dynamic>) {
      return RejectionRecord.fromJson(canonical);
    }

    final status = json['status'];
    final isRejected = status == 'rejected' ||
        (status is Map<String, dynamic> && status['value'] == 'rejected');
    final legacy = json['cancellation'];
    if (!isRejected || legacy is! Map<String, dynamic>) return null;

    return RejectionRecord(
      reason: legacy['cancellation_reason'] as String? ?? '-',
      rejectedAt: legacy['cancelled_at'] as String? ?? '',
      rejectedBy: RejectionActor.fromJson(
        legacy['cancelled_by'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}

class RejectionActor {
  final String id;
  final String name;
  final CancelReasonUserTypeEnum type;

  const RejectionActor({
    required this.id,
    required this.name,
    required this.type,
  });

  factory RejectionActor.fromJson(Map<String, dynamic> json) {
    return RejectionActor(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '-',
      type: CancelReasonUserTypeEnum.fromValue(json['type'] as String? ?? ''),
    );
  }
}
