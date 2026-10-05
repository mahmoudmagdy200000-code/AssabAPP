import 'package:equatable/equatable.dart';
import '../../../data/models/update_qty_monthly_inventory_request.dart';

sealed class UpdateQtyMonthlyInventoryEvent extends Equatable {
  const UpdateQtyMonthlyInventoryEvent();

  @override
  List<Object> get props => [];
}

final class UpdateQtyMonthlyInventoryRequested
    extends UpdateQtyMonthlyInventoryEvent {
  final String inventoryId;
  final String productId;
  final UpdateQtyMonthlyInventoryRequest request;

  const UpdateQtyMonthlyInventoryRequested({
    required this.inventoryId,
    required this.productId,
    required this.request,
  });

  @override
  List<Object> get props => [inventoryId, productId, request];
}
