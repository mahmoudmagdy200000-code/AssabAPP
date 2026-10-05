// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reassignment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReassignmentModel _$ReassignmentModelFromJson(
  Map<String, dynamic> json,
) => ReassignmentModel(
  reassignedFrom: json['reassigned_from'] == null
      ? null
      : CashierModel.fromJson(json['reassigned_from'] as Map<String, dynamic>),
  reassignedBy: json['reassigned_by'] == null
      ? null
      : CashierModel.fromJson(json['reassigned_by'] as Map<String, dynamic>),
  reassignedTo: json['reassigned_to'] == null
      ? null
      : CashierModel.fromJson(json['reassigned_to'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReassignmentModelToJson(ReassignmentModel instance) =>
    <String, dynamic>{
      'reassigned_from': instance.reassignedFrom?.toJson(),
      'reassigned_by': instance.reassignedBy?.toJson(),
      'reassigned_to': instance.reassignedTo?.toJson(),
    };
