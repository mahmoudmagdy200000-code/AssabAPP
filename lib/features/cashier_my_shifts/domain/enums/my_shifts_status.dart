import 'package:json_annotation/json_annotation.dart';

enum MyShiftStatusType {
  @JsonValue('not_started')
  pending,

  @JsonValue('Reassigned')
  @JsonValue('reassigned')
  reassigned,

  @JsonValue('In Progress')
  inProgress,

  @JsonValue('Completed')
  completed,
}
