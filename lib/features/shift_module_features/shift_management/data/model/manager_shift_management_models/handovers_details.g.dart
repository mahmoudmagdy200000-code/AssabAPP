// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handovers_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandoversDetailsModel _$HandoversDetailsModelFromJson(
  Map<String, dynamic> json,
) => HandoversDetailsModel(
  toBranchManager: (json['to_branch_manager'] as List<dynamic>)
      .map((e) => HandoverDetailsItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HandoversDetailsModelToJson(
  HandoversDetailsModel instance,
) => <String, dynamic>{'to_branch_manager': instance.toBranchManager};
