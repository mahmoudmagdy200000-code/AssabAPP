import '../../../../domain/entity/shift/shift_info_details_entity.dart';
import '../../../model/shift/shift_details/shift_info_details_model.dart';
import '../assigned_by_mapper.dart';

extension ShiftInfoDetailsMapper on ShiftInfoDetailsModel {
  ShiftInfoDetailsEntity toEntity() {
    return ShiftInfoDetailsEntity(
      id: id,
      name: name,
      branchId: branchId,
      branchName: branchName ?? 'N/A',
      isActive: isActive ?? false,
      startTime: startTime,
      endTime: endTime,
      assignedBy: assignedBy?.toEntity(),
    );
  }
}
