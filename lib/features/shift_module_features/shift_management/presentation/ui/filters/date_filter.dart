import '../../../../../../generated/l10n.dart';
import '../../../domain/entity/enums/date_filter_options.dart';

abstract class DateFilterOption {
  String get name;
  DateFilterOptions get dateOption;
}

class _FixedDateOption implements DateFilterOption {
  @override
  final String name;
  @override
  DateFilterOptions dateOption;

  _FixedDateOption({required this.name, required this.dateOption});
}

class Last24HoursOption extends _FixedDateOption {
  Last24HoursOption()
    : super(
        name: S.current.dateFilterLast24Hours,
        dateOption: DateFilterOptions.last_24_hours,
      );
}

class Last7DaysOption extends _FixedDateOption {
  Last7DaysOption()
    : super(
        name: S.current.dateFilterLast7Days,
        dateOption: DateFilterOptions.last_7_days,
      );
}

class Last14DaysOption extends _FixedDateOption {
  Last14DaysOption()
    : super(
        name: S.current.dateFilterLast14Days,
        dateOption: DateFilterOptions.last_14_days,
      );
}

class Last30DaysOption extends _FixedDateOption {
  Last30DaysOption()
    : super(
        name: S.current.dateFilterLast30Days,
        dateOption: DateFilterOptions.last_30_days,
      );
}

class Last1YearOption extends _FixedDateOption {
  Last1YearOption()
    : super(
        name: S.current.dateFilterLast1Year,
        dateOption: DateFilterOptions.last_1_year,
      );
}
