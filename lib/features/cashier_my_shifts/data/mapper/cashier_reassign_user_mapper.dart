import '../../domain/entities/cashier_reassign_user_type_entity.dart';
import '../model/shifts_models/reassigned/cashier_reassign_user_model.dart';

extension CashierReassignUserMapper on CashierReassignUserModel {
  CashierUserObjectEntity toEntity() {
    return CashierUserObjectEntity(id: id, name: name, userType: userType);
  }
}
