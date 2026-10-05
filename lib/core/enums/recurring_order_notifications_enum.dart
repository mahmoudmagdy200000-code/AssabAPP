import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum RecurringOrderNotificationsEnum {
  alert24HoursBefore('alert_24_hours_before'),
  reviewBeforeSending('review_before_sending'),
  sendAutomaticallyWithoutReview('send_automatically_without_review');

  final String _value;

  const RecurringOrderNotificationsEnum(this._value);

  String get value => _value;

  static RecurringOrderNotificationsEnum fromValue(String value) {
    return RecurringOrderNotificationsEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError(
        'Invalid RecurringOrderNotificationsEnum value: $value',
      ),
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case RecurringOrderNotificationsEnum.alert24HoursBefore:
        return context.tr.alert24HoursBefore;
      case RecurringOrderNotificationsEnum.reviewBeforeSending:
        return context.tr.reviewBeforeSending;
      case RecurringOrderNotificationsEnum.sendAutomaticallyWithoutReview:
        return context.tr.sendAutomaticallyWithoutReview;
    }
  }
}
