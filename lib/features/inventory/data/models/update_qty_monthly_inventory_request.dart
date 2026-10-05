class UpdateQtyMonthlyInventoryRequest {
  final int quantity;

  UpdateQtyMonthlyInventoryRequest({required this.quantity});

  Map<String, dynamic> toJson() => {'quantity_inventory': quantity};
}
