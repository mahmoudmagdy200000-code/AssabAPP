import 'package:json_annotation/json_annotation.dart';

part 'shift_statistics_model.g.dart';

@JsonSerializable()
class ShiftStatisticsModel {
  @JsonKey(name: 'total_cashier_shifts')
  final int? totalCashierShifts;
  @JsonKey(name: 'completed_cashier_shifts')
  final int? completedCashierShifts;
  @JsonKey(name: 'pending_cashier_shifts')
  final int? pendingCashierShifts;
  @JsonKey(name: 'completion_rate')
  final num completionRate;

  ShiftStatisticsModel({
    this.totalCashierShifts,
    this.completedCashierShifts,
    this.pendingCashierShifts,
    required this.completionRate,
  });

  factory ShiftStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftStatisticsModelToJson(this);
}
