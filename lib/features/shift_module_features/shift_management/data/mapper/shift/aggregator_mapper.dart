import '../../../domain/entity/shift/aggregator_entites.dart';
import '../../model/shift/aggregator_model.dart';

extension AggregatorMapper on AggregatorModel {
  AggregatorEntity toEntity() => AggregatorEntity(
    id: id,
    name: name,
    code: code,
    logo: logo,
    description: description,
    commissionRate: commissionRate,
    commissionPercentage: commissionPercentage,
    integrationType: integrationType,
    hasIntegration: hasIntegration,
    branchesCount: branchesCount,
    enabledBranchesCount: enabledBranchesCount,
    createdAt: createdAt,
    status: status.toEntity(),
  );
}

extension AggregatorsListMapper on List<AggregatorModel> {
  List<AggregatorEntity> toEntityList() => map((e) => e.toEntity()).toList();
}

extension AggregatorStatusMapper on AggregatorStatusModel {
  AggregatorStatusEntity toEntity() =>
      AggregatorStatusEntity(value: value, label: label, color: color);
}
