// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responsibility_details_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponsibilityDetailsDataModel _$ResponsibilityDetailsDataModelFromJson(
  Map<String, dynamic> json,
) => ResponsibilityDetailsDataModel(
  shiftId: json['shift_id'] as String,
  cashierName: json['cashier_name'] as String,
  branchName: json['branch_name'] as String,
  varianceAmount: (json['variance_amount'] as num).toDouble(),
  varianceType: $enumDecode(_$VarianceTypeEnumMap, json['variance_type']),
  shiftDate: json['shift_date'] as String,
  responsibilityStatus: ResponsibilityStatusX.fromJson(
    json['responsibility_status'] as String?,
  ),
  reviewedAt: json['reviewed_at'] as String?,
);

Map<String, dynamic> _$ResponsibilityDetailsDataModelToJson(
  ResponsibilityDetailsDataModel instance,
) => <String, dynamic>{
  'shift_id': instance.shiftId,
  'cashier_name': instance.cashierName,
  'branch_name': instance.branchName,
  'variance_amount': instance.varianceAmount,
  'variance_type': _$VarianceTypeEnumMap[instance.varianceType]!,
  'shift_date': instance.shiftDate,
  'responsibility_status': ResponsibilityDetailsDataModel._statusToJson(
    instance.responsibilityStatus,
  ),
  'reviewed_at': instance.reviewedAt,
};

const _$VarianceTypeEnumMap = {
  VarianceType.over: 'Over',
  VarianceType.short: 'Short',
  VarianceType.none: 'None',
};
