// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aggregator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AggregatorModel _$AggregatorModelFromJson(Map<String, dynamic> json) =>
    AggregatorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      logo: json['logo'] as String,
      description: json['description'] as String,
      commissionRate: (json['commission_rate'] as num).toDouble(),
      commissionPercentage: json['commission_percentage'] as String,
      status: AggregatorStatusModel.fromJson(
        json['status'] as Map<String, dynamic>,
      ),
      integrationType: json['integration_type'] as String,
      hasIntegration: json['has_integration'] as bool,
      branchesCount: (json['branches_count'] as num).toInt(),
      enabledBranchesCount: (json['enabled_branches_count'] as num).toInt(),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$AggregatorModelToJson(AggregatorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'logo': instance.logo,
      'description': instance.description,
      'commission_rate': instance.commissionRate,
      'commission_percentage': instance.commissionPercentage,
      'status': instance.status,
      'integration_type': instance.integrationType,
      'has_integration': instance.hasIntegration,
      'branches_count': instance.branchesCount,
      'enabled_branches_count': instance.enabledBranchesCount,
      'created_at': instance.createdAt,
    };

AggregatorStatusModel _$AggregatorStatusModelFromJson(
  Map<String, dynamic> json,
) => AggregatorStatusModel(
  value: json['value'] as bool,
  label: json['label'] as String,
  color: json['color'] as String,
);

Map<String, dynamic> _$AggregatorStatusModelToJson(
  AggregatorStatusModel instance,
) => <String, dynamic>{
  'value': instance.value,
  'label': instance.label,
  'color': instance.color,
};
