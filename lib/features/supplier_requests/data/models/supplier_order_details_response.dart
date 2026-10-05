import 'package:assab/shared/models/delay_details_response.dart';
import 'package:assab/shared/models/time_line_response.dart';

import '../../../../shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import 'supplier_orders_response.dart';

class SupplierOrderDetailsResponse {
  final SupplierOrder data;
  final CancelReasonInOrderResponse? reasonForRejected;
  final DelayDetails? delayDetails;
  final TimeLineResponse timelines;

  SupplierOrderDetailsResponse({
    required this.data,
    this.reasonForRejected,
    this.delayDetails,
    required this.timelines,
  });

  factory SupplierOrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SupplierOrderDetailsResponse(
      data: SupplierOrder.fromJson(json['data'] as Map<String, dynamic>),
      reasonForRejected: json['data']['reason_for_rejected'] != null
          ? CancelReasonInOrderResponse.fromJson(
              json['data']['reason_for_rejected'] as Map<String, dynamic>,
            )
          : null,
      delayDetails: json['data']['delay_details'] != null
          ? DelayDetails.fromJson(
              json['data']['delay_details'] as Map<String, dynamic>,
            )
          : null,
      timelines: TimeLineResponse.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }
}
