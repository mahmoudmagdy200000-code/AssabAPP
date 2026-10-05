import 'orders_response.dart';

class PartialApproveOrderRequest {
  String? readyTime;
  List<PartialApproveOrderItem> items;

  PartialApproveOrderRequest({
    this.readyTime,
    List<PartialApproveOrderItem>? items,
  }) : items = List<PartialApproveOrderItem>.of(items ?? []);

  Map<String, dynamic> toJson() {
    return {
      'ready_time': readyTime,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  void updateReadyTime(String readyTime) {
    this.readyTime = readyTime;
  }

  void updateItemsFromValidation({
    required Map<String, String> fieldsValue,
    required List<OrderDataItem> orderItems,
  }) {
    items
      ..clear()
      ..addAll(
        orderItems.map((item) {
          final value = fieldsValue['new_qty_${item.id}'];
          final qty = int.tryParse(value ?? '');

          if (qty == null || qty <= 0) return null;

          return PartialApproveOrderItem(itemId: item.id, quantity: qty);
        }).whereType<PartialApproveOrderItem>(),
      );
  }
}

class PartialApproveOrderItem {
  final String itemId;
  final int quantity;

  PartialApproveOrderItem({required this.itemId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'item_id': itemId, 'quantity': quantity};
  }
}
