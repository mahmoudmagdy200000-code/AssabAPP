import 'package:json_annotation/json_annotation.dart';
import '../../../../../../shared/models/meta_model/meta_model.dart';
import 'cashier_completed_shift_model.dart';

part 'cashier_completed_shifts_response_model.g.dart';

@JsonSerializable()
class CashierCompletedShiftsResponseModel {
  final bool success;
  final String message;
  final List<CashierCompletedShiftModel> data;
  final MetaModel meta;

  const CashierCompletedShiftsResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory CashierCompletedShiftsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CashierCompletedShiftsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CashierCompletedShiftsResponseModelToJson(this);
}
