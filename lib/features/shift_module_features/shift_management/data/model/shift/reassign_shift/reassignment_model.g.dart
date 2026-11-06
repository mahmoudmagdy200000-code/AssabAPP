// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reassignment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReassignmentModel _$ReassignmentModelFromJson(
  Map<String, dynamic> json,
) => ReassignmentModel(
  reassignedFrom: CashierModel.tryFromJson(json['reassigned_from']),
  reassignedBy: CashierModel.tryFromJson(json['reassigned_by']),
  reassignedTo: CashierModel.tryFromJson(json['reassigned_to']),
);

Map<String, dynamic> _$ReassignmentModelToJson(ReassignmentModel instance) =>
    <String, dynamic>{
      'reassigned_from': instance.reassignedFrom?.toJson(),
      'reassigned_by': instance.reassignedBy?.toJson(),
      'reassigned_to': instance.reassignedTo?.toJson(),
    };
