import 'package:json_annotation/json_annotation.dart';
import 'cashier_in_progress_shifts_data_model.dart';

part 'cashier_in_progress_shifts_response_model.g.dart';

@JsonSerializable()
class CashierInProgressShiftsResponseModel {
  final bool success;
  final String message;
  final CashierInProgressShiftsDataModel data;

  const CashierInProgressShiftsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CashierInProgressShiftsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CashierInProgressShiftsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CashierInProgressShiftsResponseModelToJson(this);
}
