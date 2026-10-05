import 'package:json_annotation/json_annotation.dart';

part 'cashier_shift_breakdown_model.g.dart';

@JsonSerializable()
class CashierShiftBreakdownModel {
  @JsonKey(name: 'by_status')
  final CashierShiftStatusBreakdownModel byStatus;
  @JsonKey(name: 'by_cashier')
  final List<dynamic> byCashier;
  @JsonKey(name: 'handover_status')
  final HandoverStatusBreakdownModel handoverStatus;

  CashierShiftBreakdownModel({
    required this.byStatus,
    required this.byCashier,
    required this.handoverStatus,
  });

  factory CashierShiftBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$CashierShiftBreakdownModelFromJson(json);

  Map<String, dynamic> toJson() => _$CashierShiftBreakdownModelToJson(this);
}

@JsonSerializable()
class CashierShiftStatusBreakdownModel {
  @JsonKey(name: 'not_started')
  final int notStarted;
  @JsonKey(name: 'in_progress')
  final int inProgress;
  final int completed;
  final int reassigned;

  CashierShiftStatusBreakdownModel({
    required this.notStarted,
    required this.inProgress,
    required this.completed,
    required this.reassigned,
  });

  factory CashierShiftStatusBreakdownModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CashierShiftStatusBreakdownModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CashierShiftStatusBreakdownModelToJson(this);
}

@JsonSerializable()
class HandoverStatusBreakdownModel {
  final int pending;
  final int approved;
  final int rejected;

  HandoverStatusBreakdownModel({
    required this.pending,
    required this.approved,
    required this.rejected,
  });

  factory HandoverStatusBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$HandoverStatusBreakdownModelFromJson(json);

  Map<String, dynamic> toJson() => _$HandoverStatusBreakdownModelToJson(this);
}
