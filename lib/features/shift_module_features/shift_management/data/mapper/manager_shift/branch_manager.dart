import '../../../domain/entity/cashier_entity.dart';
import '../../model/manager_shift_management_models/branch_model.dart';

extension BranchMapper on BranchModel {
  BranchEntity toEntity() => BranchEntity(id: id, name: name);
}
