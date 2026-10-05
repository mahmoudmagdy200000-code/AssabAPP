import 'aggregator_entites.dart';

class TotalSalesAggregatorEntity {
  final String aggregatorId;
  final double amount;
  final String notes;

  const TotalSalesAggregatorEntity({
    required this.aggregatorId,
    required this.amount,
    required this.notes,
  });

  factory TotalSalesAggregatorEntity.fromEntity(AggregatorEntity entity) {
    return TotalSalesAggregatorEntity(
      aggregatorId: entity.id,
      amount: entity.totalAmount ?? 0,
      notes: ' ',
    );
  }
}
