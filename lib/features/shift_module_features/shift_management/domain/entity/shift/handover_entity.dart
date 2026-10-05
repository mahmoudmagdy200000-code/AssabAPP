import '../../../../../../../core/enums/shift_status/shift_handover_status.dart';

class HandoverStatusEntity {
  final String id;
  final HandoverStatus status;
  final String reviewedBy;

  const HandoverStatusEntity({
    required this.id,
    required this.status,
    required this.reviewedBy,
  });
}
