import '../../../../domain/entity/shift/shift_cashier_entity.dart';
import '../../../model/cashier_model.dart';

extension CashierModelMapper on CashierModel {
  ShiftCashierEntity toEntity() =>
      ShiftCashierEntity(id: id.toString(), name: name);
}
