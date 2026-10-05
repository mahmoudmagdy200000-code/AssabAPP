import '../../../core/enums/cancel_reason_user_type_enum.dart';
import 'cancel_reason_response.dart';

class CancelReasonInOrderResponse {
  final String cancellationReason;
  final String cancelledAt;
  final CancelReasonInOrderCancelledBy cancelledBy;

  CancelReasonInOrderResponse({
    required this.cancellationReason,
    required this.cancelledAt,
    required this.cancelledBy,
  });

  factory CancelReasonInOrderResponse.fromJson(Map<String, dynamic> json) {
    return CancelReasonInOrderResponse(
      cancellationReason: json['cancellation_reason'] as String? ?? '-',
      cancelledAt: json['cancelled_at'] as String,
      cancelledBy: CancelReasonInOrderCancelledBy.fromJson(
        json['cancelled_by'] as Map<String, dynamic>,
      ),
    );
  }
}

class CancelReasonInOrderCancelledBy {
  final String id;
  final String name;
  final CancelReasonUserTypeEnum type;

  CancelReasonInOrderCancelledBy({
    required this.id,
    required this.name,
    required this.type,
  });

  factory CancelReasonInOrderCancelledBy.fromJson(Map<String, dynamic> json) {
    return CancelReasonInOrderCancelledBy(
      id: json['id'] as String,
      name: json['name'] as String,
      type: CancelReasonUserTypeEnum.fromValue(json['type'] as String),
    );
  }
}

extension CancelReasonInOrderResponseExtension on CancelReasonInOrderResponse {
  CancelReasonResponse toCancelReasonResponse() {
    return CancelReasonResponse(
      cancelledBy: CancelReasonResponseCancelledBy(
        id: cancelledBy.id,
        name: cancelledBy.name,
        type: cancelledBy.type,
      ),
      cancelledAt: cancelledAt,
      cancellationReason: cancellationReason,
    );
  }
}
