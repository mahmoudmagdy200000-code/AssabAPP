import 'package:json_annotation/json_annotation.dart';

part 'time_line_response_model.g.dart';

@JsonSerializable(createToJson: false, explicitToJson: true)
class TimeLineResponseModel {
  final List<TimeLineItemModel>? data;

  const TimeLineResponseModel({this.data});

  factory TimeLineResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TimeLineResponseModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class TimeLineItemModel {
  final int id;
  final ActionModel? action;
  final StatusModel? status;
  @JsonKey(name: 'performed_by')
  final PerformedByModel? performedBy;
  final String? notes;
  final String? timestamp;

  const TimeLineItemModel({
    required this.id,
    this.action,
    this.status,
    this.performedBy,
    this.notes,
    this.timestamp,
  });

  factory TimeLineItemModel.fromJson(Map<String, dynamic> json) =>
      _$TimeLineItemModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class ActionModel {
  final String? value;
  final String? label;

  const ActionModel({this.value, this.label});

  factory ActionModel.fromJson(Map<String, dynamic> json) =>
      _$ActionModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class StatusModel {
  final String? value;
  final String? label;

  const StatusModel({this.value, this.label});

  factory StatusModel.fromJson(Map<String, dynamic> json) =>
      _$StatusModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class PerformedByModel {
  final int? id;
  final String? name;
  final String? type;
  final String? image;

  const PerformedByModel({this.id, this.name, this.type, this.image});

  factory PerformedByModel.fromJson(Map<String, dynamic> json) =>
      _$PerformedByModelFromJson(json);
}
