import 'package:json_annotation/json_annotation.dart';
import 'cashier_in_progress_shift_model.dart';

part 'cashier_in_progress_shifts_data_model.g.dart';

@JsonSerializable()
class CashierInProgressShiftsDataModel {
  final List<CashierInProgressShiftModel> shifts;
  final int count;

  const CashierInProgressShiftsDataModel({
    required this.shifts,
    required this.count,
  });

  factory CashierInProgressShiftsDataModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CashierInProgressShiftsDataModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CashierInProgressShiftsDataModelToJson(this);
}
