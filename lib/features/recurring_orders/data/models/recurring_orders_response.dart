import 'package:assab/core/strategies/purchase_source_strategy.dart';
import 'package:assab/core/utils/date_formatter.dart';

import '../../../../core/enums/purchase_sources_types.dart';
import '../../../../core/enums/recurring_order_status_enum.dart';
import '../../domain/strategies/recurring_order_status_strategy.dart';

class RecurringOrdersResponse {
  final List<RecurringOrderItemResponse> data;

  const RecurringOrdersResponse({required this.data});

  factory RecurringOrdersResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>;

    final recurringOrders = dataList
        .map(
          (item) =>
              RecurringOrderItemResponse.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    return RecurringOrdersResponse(data: recurringOrders);
  }
}

class RecurringOrderItemResponse {
  final String id;
  final String orderName;
  final String type;
  final PurchaseSourceStrategy typeValue;
  final String status;
  final RecurringOrderStatusStrategy statusValue;
  final String nextScheduleDate;

  const RecurringOrderItemResponse({
    required this.id,
    required this.orderName,
    required this.type,
    required this.typeValue,
    required this.status,
    required this.statusValue,
    required this.nextScheduleDate,
  });

  factory RecurringOrderItemResponse.fromJson(Map<String, dynamic> json) {
    return RecurringOrderItemResponse(
      id: json['id'] as String,
      orderName: json['order_name'] as String,
      type: json['type'] as String,
      typeValue: PurchaseSourcesTypes.getStrategy(
        PurchaseSourcesTypes.fromValue(json['type_value'] as String),
      ),
      status: json['status'] as String,
      statusValue: RecurringOrderStatusEnum.fromString(
        json['status_value'],
      ).strategy,
      nextScheduleDate:
          DateFormatter.formatDateMDY(
            DateTime.tryParse(json['next_schedule_date'] as String? ?? ''),
          ) ??
          '-',
    );
  }
}
