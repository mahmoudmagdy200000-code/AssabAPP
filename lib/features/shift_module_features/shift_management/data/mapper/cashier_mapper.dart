import 'package:assab/features/shift_module_features/shift_management/data/mapper/working_shift_mapper.dart';

import '../../domain/entity/cashier_entity.dart';
import '../model/cashier_model.dart';

extension CashierModelMapper on CashierModel {
  CashierEntity toEntity() => CashierEntity(
    id: id,
    name: name,
    email: email ?? 'N/A',
    phone: phone ?? 'N/A',
    image: image,
    branch: BranchEntity(id: branchId, name: branchName ?? ''),
    status: status ?? CashierStatus.active,
    shiftsCount: shiftsCount ?? 0,
    workingShifts: workingShifts?.map((e) => e.toEntity()).toList(),
    createdByName: createdByName,
    createdAt: createdAt,
  );
}
