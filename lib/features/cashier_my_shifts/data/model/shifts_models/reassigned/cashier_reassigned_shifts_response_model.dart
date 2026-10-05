import 'package:json_annotation/json_annotation.dart';
import '../../../../../../shared/models/meta_model/meta_model.dart';
import 'cashier_reassigned_shift_model.dart';

part 'cashier_reassigned_shifts_response_model.g.dart';

@JsonSerializable()
class CashierReassignedShiftsResponseModel {
  final bool success;
  final String message;
  final List<CashierReassignedShiftModel> data;
  final MetaModel meta;

  const CashierReassignedShiftsResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory CashierReassignedShiftsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CashierReassignedShiftsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CashierReassignedShiftsResponseModelToJson(this);
}
