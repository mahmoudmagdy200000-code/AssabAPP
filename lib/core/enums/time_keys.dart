import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum TimeKeys {
  non(''),
  last24Hours('last_24_hours'),
  last7Days('last_7_days'),
  last30Days('last_30_days'),
  last6Months('last_6_months'),
  custom('custom');

  final String _key;

  const TimeKeys(this._key);

  String get key => _key;

  String? getDisplayName(BuildContext context) {
    switch (this) {
      case TimeKeys.last24Hours:
        return context.tr.last24Hours;
      case TimeKeys.last7Days:
        return context.tr.last7Days;
      case TimeKeys.last30Days:
        return context.tr.last30Days;
      case TimeKeys.last6Months:
        return context.tr.last6Months;
      case TimeKeys.custom:
        return context.tr.custom;
      case TimeKeys.non:
        return null;
    }
  }
}
