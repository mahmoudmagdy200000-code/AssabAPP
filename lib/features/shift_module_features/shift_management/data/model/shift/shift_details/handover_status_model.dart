import 'package:json_annotation/json_annotation.dart';

import '../../../../../../../core/enums/shift_status/shift_handover_status.dart';

part 'handover_status_model.g.dart';

@JsonSerializable()
class HandoverStatusModel {
  final String id;
  @JsonKey(fromJson: handoverStatusFromJson, toJson: handoverStatusToJson)
  final HandoverStatus status;

  @JsonKey(name: 'reviewed_by')
  final String? reviewedBy;

  HandoverStatusModel({
    required this.id,
    required this.status,
    required this.reviewedBy,
  });

  factory HandoverStatusModel.fromJson(Map<String, dynamic> json) =>
      _$HandoverStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$HandoverStatusModelToJson(this);
}
