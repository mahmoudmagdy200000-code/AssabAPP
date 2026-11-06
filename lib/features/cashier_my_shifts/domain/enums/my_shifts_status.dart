import 'package:json_annotation/json_annotation.dart';

enum MyShiftStatusType {
  @JsonValue('not_started')
  pending,

  @JsonValue('Reassigned')
  reassigned,

  @JsonValue('In Progress')
  inProgress,

  @JsonValue('Completed')
  completed;

  static MyShiftStatusType fromJson(Object? raw) {
    if (raw == null) return MyShiftStatusType.pending;
    final str = raw.toString().trim().toLowerCase();
    switch (str) {
      case 'reassigned':
        return MyShiftStatusType.reassigned;
      case 'in_progress':
      case 'in progress':
      case 'inprogress':
        return MyShiftStatusType.inProgress;
      case 'completed':
        return MyShiftStatusType.completed;
      case 'not_started':
      case 'pending':
      default:
        return MyShiftStatusType.pending;
    }
  }

  static String? extractUserName(Object? raw) {
    if (raw == null) return null;
    if (raw is String) return raw.trim().isEmpty ? null : raw;
    if (raw is Map<String, dynamic>) {
      final name = raw['name']?.toString().trim();
      return (name == null || name.isEmpty) ? null : name;
    }
    return raw.toString();
  }
}
