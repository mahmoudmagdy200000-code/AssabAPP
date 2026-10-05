import 'package:assab/core/utils/date_formatter.dart';

import '../../core/enums/time_line_enum.dart';
import '../../core/strategies/time_line_strategy.dart';

class TimeLineResponse {
  final List<TimeLineItem> timelines;

  const TimeLineResponse({required this.timelines});

  factory TimeLineResponse.fromJson(Map<String, dynamic> json) {
    return TimeLineResponse(
      timelines:
          ((json['timelines'] as List?) ?? (json['timeline'] as List?) ?? [])
              .map((e) => TimeLineItem.fromJson(e))
              .toList(),
    );
  }
}

class TimeLineItem {
  final String id;
  final TimeLineStrategy eventType;
  final String name;
  final String? image;
  final String occurredAt;

  const TimeLineItem({
    required this.id,
    required this.eventType,
    required this.name,
    this.image,
    required this.occurredAt,
  });

  factory TimeLineItem.fromJson(Map<String, dynamic> json) {
    return TimeLineItem(
      id: json['id'] as String,
      eventType: TimeLineEnum.fromValue(json['event_type'] as String).strategy,
      name: json['name'] as String,
      image: json['image'] as String?,
      occurredAt:
          '${DateFormatter.formatDateMDY(DateTime.tryParse(json['occurred_at'] as String))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(json['occurred_at'] as String))}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_type': eventType,
      'name': name,
      'image': image,
      'occurred_at': occurredAt,
    };
  }
}
