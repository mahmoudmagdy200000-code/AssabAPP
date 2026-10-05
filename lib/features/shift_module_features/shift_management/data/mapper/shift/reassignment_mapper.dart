import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/shift_cashier_mapper.dart';

import '../../../domain/entity/shift/reassignment_entity.dart';
import '../../model/shift/reassign_shift/reassignment_model.dart';

extension ReassignmentModelMapper on ReassignmentModel {
  ReassignmentEntity toEntity() => ReassignmentEntity(
    reassignedFrom: reassignedFrom?.toEntity(),
    reassignedBy: reassignedBy?.toEntity(),
    reassignedTo: reassignedTo?.toEntity(),
  );
}
