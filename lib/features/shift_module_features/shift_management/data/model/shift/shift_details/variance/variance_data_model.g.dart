// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variance_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VarianceDataModel _$VarianceDataModelFromJson(Map<String, dynamic> json) =>
    VarianceDataModel(
      hasVariance: json['has_variance'] as bool,
      variance: json['variance'] == null
          ? null
          : VarianceModel.fromJson(json['variance'] as Map<String, dynamic>),
      varianceRecorded: json['variance_recorded'] as bool,
    );

Map<String, dynamic> _$VarianceDataModelToJson(VarianceDataModel instance) =>
    <String, dynamic>{
      'has_variance': instance.hasVariance,
      'variance': instance.variance,
      'variance_recorded': instance.varianceRecorded,
    };

VarianceModel _$VarianceModelFromJson(Map<String, dynamic> json) =>
    VarianceModel(
      responsibilityType: json['responsibility_type'] as String,
      currentCashierAmount: (json['current_cashier_amount'] as num).toDouble(),
      otherCashiers: (json['other_cashiers'] as List<dynamic>)
          .map(
            (e) =>
                VarianceOtherCashierModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      reason: json['reason'] as String?,
      supportingFiles: (json['supporting_files'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalVarianceAmount: (json['total_variance_amount'] as num).toDouble(),
      varianceType: $enumDecode(_$VarianceTypeEnumMap, json['variance_type']),
    );

Map<String, dynamic> _$VarianceModelToJson(VarianceModel instance) =>
    <String, dynamic>{
      'responsibility_type': instance.responsibilityType,
      'current_cashier_amount': instance.currentCashierAmount,
      'other_cashiers': instance.otherCashiers,
      'reason': instance.reason,
      'supporting_files': instance.supportingFiles,
      'total_variance_amount': instance.totalVarianceAmount,
      'variance_type': _$VarianceTypeEnumMap[instance.varianceType]!,
    };

const _$VarianceTypeEnumMap = {
  VarianceType.over: 'Over',
  VarianceType.short: 'Short',
  VarianceType.none: 'None',
};

VarianceOtherCashierModel _$VarianceOtherCashierModelFromJson(
  Map<String, dynamic> json,
) => VarianceOtherCashierModel(
  cashierId: json['cashier_id'] as String,
  cashierName: json['cashier_name'] as String,
  amount: (json['amount'] as num).toDouble(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$VarianceOtherCashierModelToJson(
  VarianceOtherCashierModel instance,
) => <String, dynamic>{
  'cashier_id': instance.cashierId,
  'cashier_name': instance.cashierName,
  'amount': instance.amount,
  'notes': instance.notes,
};
