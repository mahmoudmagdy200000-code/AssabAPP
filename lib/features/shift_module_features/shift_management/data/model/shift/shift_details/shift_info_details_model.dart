import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shift_details/shift_details_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shift_info_details_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShiftInfoDetailsModel {
  final String id;
  final String name;

  @JsonKey(name: 'branch_id')
  final String branchId;

  @JsonKey(name: 'branch_name')
  final String? branchName;

  @JsonKey(name: 'is_active')
  final bool? isActive;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  @JsonKey(name: 'assigned_by')
  final AssignedByModel? assignedBy;

  ShiftInfoDetailsModel({
    required this.id,
    required this.name,
    required this.branchId,
    required this.branchName,
    required this.isActive,
    required this.startTime,
    required this.endTime,
    required this.assignedBy,
  });

  factory ShiftInfoDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftInfoDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftInfoDetailsModelToJson(this);
}
