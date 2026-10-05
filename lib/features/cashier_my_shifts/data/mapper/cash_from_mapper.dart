import '../../domain/entities/cashier_reassign_user_type_entity.dart';
import '../model/shifts_models/cashier_shifts_user_model.dart';

extension CashFromMapper on CashierShiftUserModel {
  CashierUserObjectEntity toEntity() {
    return CashierUserObjectEntity(id: id, name: name, userType: userType);
  }
}
