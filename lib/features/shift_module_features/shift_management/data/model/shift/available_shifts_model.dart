import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shift_details/shift_info_details_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../../shared/models/meta_model/meta_model.dart';

part 'available_shifts_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AvailableShiftResponseModel {
  final bool success;
  final String message;
  @JsonKey(name: 'data')
  final List<ShiftInfoDetailsModel> shifts;
  final MetaModel meta;

  AvailableShiftResponseModel({
    required this.success,
    required this.message,
    required this.shifts,
    required this.meta,
  });

  factory AvailableShiftResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AvailableShiftResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableShiftResponseModelToJson(this);
}
