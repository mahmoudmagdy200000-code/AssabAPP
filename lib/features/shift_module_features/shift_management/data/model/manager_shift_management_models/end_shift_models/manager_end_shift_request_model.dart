import 'package:assab/features/shift_module_features/shift_management/domain/enums/manager_shift/end_shift_handover_timing.dart';
import 'package:json_annotation/json_annotation.dart';

import 'cashier_breakdown_request_model.dart';

part 'manager_end_shift_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EndManagerShiftRequestModel {
  @JsonKey(name: 'handover_to')
  final String? handoverTo;

  @JsonKey(name: 'handover_amount')
  final double? handoverAmount;

  /// today | yesterday
  @JsonKey(name: 'handover_timing')
  final HandoverTiming handoverTiming;

  @JsonKey(name: 'handover_notes')
  final String? handoverNotes;

  // Financial values
  @JsonKey(name: 'total_sales')
  final double? totalSales;

  @JsonKey(name: 'cash_collected')
  final double? cashCollected;

  @JsonKey(name: 'card_payments')
  final double? cardPayments;

  @JsonKey(name: 'aggregator_payments')
  final double? aggregatorPayments;

  // Cashier breakdown (dedicated request DTO without derived fields)
  @JsonKey(name: 'cashier_breakdown')
  final List<CashierBreakdownRequestModel>? cashierBreakdown;

  const EndManagerShiftRequestModel({
    this.handoverTo,
    this.handoverAmount,
    required this.handoverTiming,
    this.handoverNotes,
    this.totalSales,
    this.cashCollected,
    this.cardPayments,
    this.aggregatorPayments,
    this.cashierBreakdown,
  });

  factory EndManagerShiftRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EndManagerShiftRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$EndManagerShiftRequestModelToJson(this);
}