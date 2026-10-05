import 'supplier_orders_response.dart';

class SupplierPartialConfirmItemLocalModel {
  final SupplierOrderItem item;
  final String orderId;
  final String newQty;
  final String shortage;
  final String originalPrice;
  final String newPrice;
  final String differencePrice;
  final String modificationNotes;

  SupplierPartialConfirmItemLocalModel({
    required this.item,
    required this.orderId,
    required this.newQty,
    required this.shortage,
    required this.originalPrice,
    required this.newPrice,
    required this.differencePrice,
    required this.modificationNotes,
  });
}
