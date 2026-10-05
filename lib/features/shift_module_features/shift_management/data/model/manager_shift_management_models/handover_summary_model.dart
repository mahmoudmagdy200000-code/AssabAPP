import 'package:json_annotation/json_annotation.dart';

part 'handover_summary_model.g.dart';

@JsonSerializable()
class HandoversSummary {
  @JsonKey(name: 'total_handovers')
  final int totalHandovers;

  final int approved;
  final int pending;
  final int rejected;

  @JsonKey(name: 'total_amount')
  final num totalAmount;

  HandoversSummary({
    required this.totalHandovers,
    required this.approved,
    required this.pending,
    required this.rejected,
    required this.totalAmount,
  });

  factory HandoversSummary.fromJson(Map<String, dynamic> json) =>
      _$HandoversSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$HandoversSummaryToJson(this);
}
