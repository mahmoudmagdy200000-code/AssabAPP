import 'package:json_annotation/json_annotation.dart';

part 'final_handover_model.g.dart';

@JsonSerializable()
class EndShiftFinalHandoverModel {
  @JsonKey(name: 'handover_amount')
  final double? handoverAmount;

  final String? status;

  @JsonKey(name: 'handover_from')
  final String? handoverFrom;

  @JsonKey(name: 'handover_to')
  final String? handoverTo;

  @JsonKey(name: 'handover_date')
  final String? handoverDate;

  @JsonKey(name: 'handover_time')
  final String? handoverTime;

  @JsonKey(name: 'handover_notes')
  final String? handoverNotes;

  const EndShiftFinalHandoverModel({
    this.handoverAmount,
    this.status,
    this.handoverFrom,
    this.handoverTo,
    this.handoverDate,
    this.handoverTime,
    this.handoverNotes,
  });

  factory EndShiftFinalHandoverModel.fromJson(Map<String, dynamic> json) =>
      _$EndShiftFinalHandoverModelFromJson(json);

  Map<String, dynamic> toJson() => _$EndShiftFinalHandoverModelToJson(this);
}
