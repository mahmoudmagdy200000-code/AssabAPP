import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/shift_progress.dart';
import 'package:json_annotation/json_annotation.dart';

import 'handover_summary_model.dart';
import 'handovers_details.dart';
import 'manager_shift_model.dart';

part 'current_shift_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CurrentShiftDataModel {
  final ManagerShiftModel shift;

  @JsonKey(name: 'shift_progress')
  final ShiftProgress shiftProgress;

  @JsonKey(name: 'handovers_summary')
  final HandoversSummary handoversSummary;

  @JsonKey(name: 'handovers_details')
  final HandoversDetailsModel handoversDetails;

  @JsonKey(name: 'can_start')
  final bool canStart;

  @JsonKey(name: 'can_end')
  final bool canEnd;

  @JsonKey(name: 'pending_handovers')
  final int pendingHandovers;

  CurrentShiftDataModel({
    required this.shift,
    required this.shiftProgress,
    required this.handoversSummary,
    required this.handoversDetails,
    required this.canStart,
    required this.canEnd,
    required this.pendingHandovers,
  });

  factory CurrentShiftDataModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentShiftDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentShiftDataModelToJson(this);
}
