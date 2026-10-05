import '../../../domain/entity/shift/assigned_by_entity.dart';
import '../../model/shift/shift_details/shift_details_model.dart';

extension AssignedByMapper on AssignedByModel {
  AssignedByEntity toEntity() {
    return AssignedByEntity(
      id: id ?? 'N/A',
      name: name ?? 'N/A',
      userType: userType,
    );
  }
}
