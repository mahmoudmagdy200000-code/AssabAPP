import 'package:json_annotation/json_annotation.dart';

part 'handoffs_summary.g.dart';

@JsonSerializable()
class HandoffsSummary {
  @JsonKey(name: 'total_handovers')
  final int totalHandovers;

  final int approved;
  final int pending;
  final int rejected;

  @JsonKey(name: 'rejected_final')
  final int rejectedFinal;

  @JsonKey(name: 'total_amount')
  final num totalAmount;

  @JsonKey(name: 'total_variance')
  final num totalVariance;

  @JsonKey(name: 'all_received')
  final bool allReceived;

  HandoffsSummary({
    required this.totalHandovers,
    required this.approved,
    required this.pending,
    required this.rejected,
    required this.rejectedFinal,
    required this.totalAmount,
    required this.totalVariance,
    required this.allReceived,
  });

  factory HandoffsSummary.fromJson(Map<String, dynamic> json) =>
      _$HandoffsSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$HandoffsSummaryToJson(this);
}
