// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variance_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VarianceDetailsModel _$VarianceDetailsModelFromJson(
  Map<String, dynamic> json,
) => VarianceDetailsModel(
  totalSales: (json['total_sales'] as num).toDouble(),
  handoverAmount: (json['handover_amount'] as num).toDouble(),
  varianceAmount: (json['variance_amount'] as num).toDouble(),
  varianceType: $enumDecode(_$VarianceTypeEnumMap, json['variance_type']),
  reasonForVariance: json['reason_for_variance'] as String?,
  attachedFiles: (json['attached_files'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  cashierDetails: CashierDetailsModel.fromJson(
    json['cashier_details'] as Map<String, dynamic>,
  ),
  otherCashiers: (json['other_cashiers'] as List<dynamic>?)
      ?.map((e) => OtherCashierModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VarianceDetailsModelToJson(
  VarianceDetailsModel instance,
) => <String, dynamic>{
  'total_sales': instance.totalSales,
  'handover_amount': instance.handoverAmount,
  'variance_amount': instance.varianceAmount,
  'variance_type': _$VarianceTypeEnumMap[instance.varianceType]!,
  'reason_for_variance': instance.reasonForVariance,
  'attached_files': instance.attachedFiles,
  'cashier_details': instance.cashierDetails,
  'other_cashiers': instance.otherCashiers,
};

const _$VarianceTypeEnumMap = {
  VarianceType.over: 'Over',
  VarianceType.short: 'Short',
  VarianceType.none: 'None',
};
