import 'package:json_annotation/json_annotation.dart';

import 'daily_totals_model.dart';
import 'final_handover_model.dart';

part 'manager_shift_end_data_model.g.dart';

@JsonSerializable()
class ManagerShiftEndDataModel {
  @JsonKey(name: 'final_handover')
  final EndShiftFinalHandoverModel? finalHandover;
  @JsonKey(name: 'daily_totals')
  final DailyTotalsModel? dailyTotals;

  ManagerShiftEndDataModel({
    required this.finalHandover,
    required this.dailyTotals,
  });

  factory ManagerShiftEndDataModel.fromJson(Map<String, dynamic> json) =>
      _$ManagerShiftEndDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManagerShiftEndDataModelToJson(this);
}
