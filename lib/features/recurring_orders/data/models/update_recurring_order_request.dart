import 'create_recurring_order_request.dart';

class UpdateRecurringOrderRequest {
  final String? repeatFrequency;
  final CreateRecurringOrderRequestRepeatConfig? repeatConfig;
  final String? schedulingTime;
  final String? meridiem;
  final List<String>? notificationOptions;
  final List<String>? smartSettings;
  final String? startDate;
  final String? endDate;
  final String? endType;

  UpdateRecurringOrderRequest({
    required this.repeatFrequency,
    required this.repeatConfig,
    required this.schedulingTime,
    required this.meridiem,
    required this.notificationOptions,
    required this.smartSettings,
    required this.startDate,
    required this.endDate,
    required this.endType,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (repeatFrequency != null) {
      data['repeat_frequency'] = repeatFrequency;
    }

    if (repeatConfig != null) {
      data['repeat_config'] = repeatConfig!.toJson();
    }

    if (schedulingTime != null) {
      data['scheduling_time'] = schedulingTime;
    }

    if (meridiem != null) {
      data['meridiem'] = meridiem;
    }

    if (notificationOptions != null) {
      data['notification_options'] = notificationOptions;
    }

    if (smartSettings != null) {
      data['smart_settings'] = smartSettings;
    }

    if (startDate != null) {
      data['start_date'] = startDate;
    }

    if (endDate != null) {
      data['end_date'] = endDate;
    }

    if (endType != null) {
      data['end_type'] = endType;
    }

    return data;
  }
}
