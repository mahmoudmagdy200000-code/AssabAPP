// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchesResponseModel _$BranchesResponseModelFromJson(
  Map<String, dynamic> json,
) => BranchesResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BranchesResponseModelToJson(
  BranchesResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};
