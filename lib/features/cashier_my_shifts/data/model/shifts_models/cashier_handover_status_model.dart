import 'package:json_annotation/json_annotation.dart';

import '../../../domain/enums/cashier_my_shifts_handover_status.dart';

part 'cashier_handover_status_model.g.dart';

@JsonSerializable()
class CashierHandoverStatusModel {
  @JsonKey(name: 'status', fromJson: cashierMyShiftsHandoverStatusFromJson)
  final CashierMyShiftsHandoverStatus status;

  @JsonKey(name: 'reviewed_by')
  final String? reviewedBy;

  const CashierHandoverStatusModel({required this.status, this.reviewedBy});

  factory CashierHandoverStatusModel.fromJson(Map<String, dynamic> json) =>
      _$CashierHandoverStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierHandoverStatusModelToJson(this);
}
