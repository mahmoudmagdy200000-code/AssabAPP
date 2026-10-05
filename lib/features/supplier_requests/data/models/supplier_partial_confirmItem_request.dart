class SupplierPartialConfirmItemRequest {
  final List<SupplierPartialConfirmItemRequestItem> items;

  SupplierPartialConfirmItemRequest({required this.items});

  factory SupplierPartialConfirmItemRequest.fromJson(
    Map<String, dynamic> json,
  ) {
    return SupplierPartialConfirmItemRequest(
      items: (json['items'] as List)
          .map(
            (e) => SupplierPartialConfirmItemRequestItem.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'items': items.map((e) => e.toJson()).toList()};
  }
}

class SupplierPartialConfirmItemRequestItem {
  final String itemId;
  final double quantity;
  final String note;

  SupplierPartialConfirmItemRequestItem({
    required this.itemId,
    required this.quantity,
    required this.note,
  });

  factory SupplierPartialConfirmItemRequestItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return SupplierPartialConfirmItemRequestItem(
      itemId: json['item_id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      note: json['note'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'item_id': itemId, 'quantity': quantity, 'message': note};
  }
}
