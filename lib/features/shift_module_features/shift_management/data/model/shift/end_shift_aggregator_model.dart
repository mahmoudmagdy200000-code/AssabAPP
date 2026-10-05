import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entity/shift/end_shift_aggregator_entity.dart';

part 'end_shift_aggregator_model.g.dart';

@JsonSerializable()
class EndShiftAggregatorModel {
  @JsonKey(name: 'aggregator_id')
  final String aggregatorId;

  final double amount;
  final String notes;

  const EndShiftAggregatorModel({
    required this.aggregatorId,
    required this.amount,
    required this.notes,
  });

  factory EndShiftAggregatorModel.fromJson(Map<String, dynamic> json) =>
      _$EndShiftAggregatorModelFromJson(json);

  Map<String, dynamic> toJson() => _$EndShiftAggregatorModelToJson(this);

  // Mapper from entity → model
  factory EndShiftAggregatorModel.fromEntity(
    TotalSalesAggregatorEntity entity,
  ) {
    return EndShiftAggregatorModel(
      aggregatorId: entity.aggregatorId,
      amount: entity.amount,
      notes: entity.notes,
    );
  }
}
