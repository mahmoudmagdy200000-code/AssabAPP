import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum DateFilterOptions {
  last_24_hours,
  last_7_days,
  last_14_days,
  last_30_days,
  last_1_year,
}

extension DateFilterOptionsExtension on DateFilterOptions {
  String displayName(BuildContext context) {
    switch (this) {
      case DateFilterOptions.last_24_hours:
        return context.tr.dateFilterLast24Hours;
      case DateFilterOptions.last_7_days:
        return context.tr.dateFilterLast7Days;
      case DateFilterOptions.last_14_days:
        return context.tr.dateFilterLast14Days;
      case DateFilterOptions.last_30_days:
        return context.tr.dateFilterLast30Days;
      case DateFilterOptions.last_1_year:
        return context.tr.dateFilterLast1Year;
    }
  }

  String get apiKey {
    switch (this) {
      case DateFilterOptions.last_24_hours:
        return 'last_24_hours';
      case DateFilterOptions.last_7_days:
        return 'last_7_days';
      case DateFilterOptions.last_14_days:
        return 'last_14_days';
      case DateFilterOptions.last_30_days:
        return 'last_30_days';
      case DateFilterOptions.last_1_year:
        return 'last_1_year';
    }
  }
}
