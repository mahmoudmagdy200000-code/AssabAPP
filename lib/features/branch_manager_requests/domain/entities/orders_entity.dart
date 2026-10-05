import 'package:assab/features/branch_manager_requests/data/models/orders_response.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';

class OrdersEntity {
  final List<OrderData> orders;
  final MetaModel meta;

  OrdersEntity({required this.orders, required this.meta});
}
