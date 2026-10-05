import 'package:json_annotation/json_annotation.dart';

part 'progress_statistics_model.g.dart';

@JsonSerializable()
class ProgressStatisticsModel {
  final int? totalShifts;
  final int? completedShifts;
  final int? pendingShifts;

  ProgressStatisticsModel({
    this.totalShifts,
    this.completedShifts,
    this.pendingShifts,
  });

  factory ProgressStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$ProgressStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressStatisticsModelToJson(this);
}
