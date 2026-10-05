import 'package:json_annotation/json_annotation.dart';
import '../../../../../../shared/models/meta_model/meta_model.dart';
import 'cashier_pending_shift_model.dart';

part 'cashier_pending_shifts_response_model.g.dart';

@JsonSerializable()
class CashierPendingShiftsResponseModel {
  final bool success;
  final String message;
  final List<CashierPendingShiftModel> data;
  final MetaModel meta;

  const CashierPendingShiftsResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory CashierPendingShiftsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CashierPendingShiftsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CashierPendingShiftsResponseModelToJson(this);
}
