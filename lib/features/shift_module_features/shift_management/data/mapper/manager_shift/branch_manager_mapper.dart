import '../../../domain/entity/manager_shift/current_shift/branch_manager_entity.dart';
import '../../model/manager_shift_management_models/will_be_deleted/branch_manager_model.dart';

extension BranchManagerMapper on BranchManagerModel {
  BranchManagerEntity toEntity() => BranchManagerEntity(id: id, name: name);
}
