import 'package:json_annotation/json_annotation.dart';

import 'daily_totals_model.dart';
import 'final_handover_model.dart';

part 'manager_shift_update_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ManagerShiftUpdateResponseModel {
  final bool success;
  final String message;
  final ManagerShiftUpdateDataModel data;

  ManagerShiftUpdateResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ManagerShiftUpdateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ManagerShiftUpdateResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ManagerShiftUpdateResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ManagerShiftUpdateDataModel {
  final ManagerHandoverShiftModel shift;

  @JsonKey(name: 'daily_totals')
  final DailyTotalsModel dailyTotals;

  ManagerShiftUpdateDataModel({required this.shift, required this.dailyTotals});

  factory ManagerShiftUpdateDataModel.fromJson(Map<String, dynamic> json) =>
      _$ManagerShiftUpdateDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManagerShiftUpdateDataModelToJson(this);
}

@JsonSerializable()
class ManagerHandoverShiftModel {
  @JsonKey(name: 'final_handover')
  final EndShiftFinalHandoverModel finalHandover;

  ManagerHandoverShiftModel({required this.finalHandover});

  factory ManagerHandoverShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ManagerHandoverShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManagerHandoverShiftModelToJson(this);
}
