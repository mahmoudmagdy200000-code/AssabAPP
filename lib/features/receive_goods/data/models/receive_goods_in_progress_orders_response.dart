import 'package:assab/core/enums/purchase_sources_types.dart';
import 'package:assab/core/enums/requests_order_status_enum.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';

import '../../../../core/strategies/purchase_source_strategy.dart';
import '../../../../core/strategies/requests_order_status_strategy.dart';

class ReceiveGoodsInProgressOrdersResponse {
  final List<ReceiveGoodsOrder> data;
  final MetaModel meta;

  ReceiveGoodsInProgressOrdersResponse({
    required this.data,
    required this.meta,
  });

  factory ReceiveGoodsInProgressOrdersResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReceiveGoodsInProgressOrdersResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ReceiveGoodsOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

class ReceiveGoodsOrder {
  final int itemsCount;

  final String orderId;

  final PurchaseSourceStrategy orderType;

  final RequestsOrderStatusStrategy status;

  final String date;

  ReceiveGoodsOrder({
    required this.itemsCount,
    required this.orderId,
    required this.orderType,
    required this.status,
    required this.date,
  });

  factory ReceiveGoodsOrder.fromJson(Map<String, dynamic> json) {
    return ReceiveGoodsOrder(
      itemsCount: (json['items_count'] as num).toInt(),
      orderId: json['id'] as String,
      orderType: PurchaseSourcesTypes.getStrategy(
        PurchaseSourcesTypes.fromValue(json['type'] as String),
      ),
      status: RequestsOrderStatusEnum.getStatusStrategy(
        RequestsOrderStatusEnum.fromString(json['status'] as String),
      ),
      date: json['date'] as String,
    );
  }
}
