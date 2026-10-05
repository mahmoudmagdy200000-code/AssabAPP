// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_approval_previous_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreApprovalPreviousResponse _$PreApprovalPreviousResponseFromJson(
  Map<String, dynamic> json,
) => PreApprovalPreviousResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => PreApprovalDataModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);
