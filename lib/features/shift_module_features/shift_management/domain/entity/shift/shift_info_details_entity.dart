import 'package:assab/core/utils/shift_time_formatter.dart';

import 'assigned_by_entity.dart';

class ShiftInfoDetailsEntity {
  final String id;
  final String name;
  final String branchId;
  final String branchName;
  final bool isActive;
  final String startTime;
  final String endTime;
  final AssignedByEntity? assignedBy;

  ShiftInfoDetailsEntity({
    required this.id,
    required this.name,
    required this.branchId,
    required this.branchName,
    required this.isActive,
    required this.startTime,
    required this.endTime,
    this.assignedBy,
  });

  String? formatTime12(String? time24) {
    if (time24 == null) return null;
    final formatted = ShiftTimeFormatter.format(time24);
    return formatted == '—' ? null : formatted;
  }
}
