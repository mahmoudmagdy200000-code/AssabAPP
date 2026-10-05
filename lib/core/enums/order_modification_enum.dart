import '../../features/branch_manager_requests/domain/strategies/branch_order_modification_strategy.dart';
import '../../features/supplier_requests/domain/strategies/supplier_order_modification_strategy.dart';

enum OrderModificationEnum {
  newQuantity('new_quantity'),
  newTime('need_time'),
  newItem('alternative_product');

  final String _value;

  const OrderModificationEnum(this._value);

  String get value => _value;

  static OrderModificationEnum fromValue(String value) {
    return OrderModificationEnum.values.firstWhere(
      (element) => element.value == value,
      orElse: () =>
          throw Exception('Invalid SupplierOrderModificationEnum value'),
    );
  }

  static SupplierOrderModificationStrategy getSupplierStrategy(
    OrderModificationEnum modificationEnum,
  ) {
    switch (modificationEnum) {
      case OrderModificationEnum.newQuantity:
        return NewQuantitySupplierOrderModificationStrategy();
      case OrderModificationEnum.newTime:
        return NewTimeSupplierOrderModificationStrategy();
      case OrderModificationEnum.newItem:
        return NewItemSupplierOrderModificationStrategy();
    }
  }

  static BranchOrderModificationStrategy getBranchStrategy(
    OrderModificationEnum modificationEnum,
  ) {
    switch (modificationEnum) {
      case OrderModificationEnum.newQuantity:
        return NewQuantityBranchOrderModificationStrategy();
      case OrderModificationEnum.newTime:
        return NewTimeBranchOrderModificationStrategy();
      case OrderModificationEnum.newItem:
        return NewItemBranchOrderModificationStrategy();
    }
  }
}
