import '../../../core/enums/cancel_reason_user_type_enum.dart';

class CancelReasonResponse {
  final String cancellationReason;
  final String cancelledAt;
  final CancelReasonResponseCancelledBy cancelledBy;

  CancelReasonResponse({
    required this.cancellationReason,
    required this.cancelledAt,
    required this.cancelledBy,
  });

  factory CancelReasonResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data']['cancellation'] as Map<String, dynamic>;

    return CancelReasonResponse(
      cancellationReason: data['cancellation_reason'] as String? ?? '-',
      cancelledAt: data['cancelled_at'] as String,
      cancelledBy: CancelReasonResponseCancelledBy.fromJson(
        data['cancelled_by'] as Map<String, dynamic>,
      ),
    );
  }
}

class CancelReasonResponseCancelledBy {
  final String id;
  final String name;
  final CancelReasonUserTypeEnum type;

  CancelReasonResponseCancelledBy({
    required this.id,
    required this.name,
    required this.type,
  });

  factory CancelReasonResponseCancelledBy.fromJson(Map<String, dynamic> json) {
    return CancelReasonResponseCancelledBy(
      id: json['id'] as String,
      name: json['name'] as String,
      type: CancelReasonUserTypeEnum.fromValue(json['type'] as String),
    );
  }
}
