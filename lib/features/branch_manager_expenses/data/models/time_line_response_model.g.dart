// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_line_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeLineResponseModel _$TimeLineResponseModelFromJson(
  Map<String, dynamic> json,
) => TimeLineResponseModel(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => TimeLineItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

TimeLineItemModel _$TimeLineItemModelFromJson(Map<String, dynamic> json) =>
    TimeLineItemModel(
      id: (json['id'] as num).toInt(),
      action: json['action'] == null
          ? null
          : ActionModel.fromJson(json['action'] as Map<String, dynamic>),
      status: json['status'] == null
          ? null
          : StatusModel.fromJson(json['status'] as Map<String, dynamic>),
      performedBy: json['performed_by'] == null
          ? null
          : PerformedByModel.fromJson(
              json['performed_by'] as Map<String, dynamic>,
            ),
      notes: json['notes'] as String?,
      timestamp: json['timestamp'] as String?,
    );

ActionModel _$ActionModelFromJson(Map<String, dynamic> json) => ActionModel(
  value: json['value'] as String?,
  label: json['label'] as String?,
);

StatusModel _$StatusModelFromJson(Map<String, dynamic> json) => StatusModel(
  value: json['value'] as String?,
  label: json['label'] as String?,
);

PerformedByModel _$PerformedByModelFromJson(Map<String, dynamic> json) =>
    PerformedByModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      type: json['type'] as String?,
      image: json['image'] as String?,
    );
