import 'package:json_annotation/json_annotation.dart';

part 'aggregator_model.g.dart';

@JsonSerializable()
class AggregatorModel {
  final String id;
  final String name;
  final String code;
  final String logo;
  final String description;
  @JsonKey(name: 'commission_rate')
  final double commissionRate;
  @JsonKey(name: 'commission_percentage')
  final String commissionPercentage;
  final AggregatorStatusModel status;
  @JsonKey(name: 'integration_type')
  final String integrationType;
  @JsonKey(name: 'has_integration')
  final bool hasIntegration;
  @JsonKey(name: 'branches_count')
  final int branchesCount;
  @JsonKey(name: 'enabled_branches_count')
  final int enabledBranchesCount;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const AggregatorModel({
    required this.id,
    required this.name,
    required this.code,
    required this.logo,
    required this.description,
    required this.commissionRate,
    required this.commissionPercentage,
    required this.status,
    required this.integrationType,
    required this.hasIntegration,
    required this.branchesCount,
    required this.enabledBranchesCount,
    required this.createdAt,
  });

  factory AggregatorModel.fromJson(Map<String, dynamic> json) =>
      _$AggregatorModelFromJson(json);
  Map<String, dynamic> toJson() => _$AggregatorModelToJson(this);
}

@JsonSerializable()
class AggregatorStatusModel {
  final bool value;
  final String label;
  final String color;

  const AggregatorStatusModel({
    required this.value,
    required this.label,
    required this.color,
  });

  factory AggregatorStatusModel.fromJson(Map<String, dynamic> json) =>
      _$AggregatorStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$AggregatorStatusModelToJson(this);
}
