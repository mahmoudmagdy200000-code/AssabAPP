enum RecurringOrderActivatePeriodEndDateEnum {
  open('repeat'),
  custom('date');

  final String _value;

  const RecurringOrderActivatePeriodEndDateEnum(this._value);

  String get value => _value;

  static RecurringOrderActivatePeriodEndDateEnum fromValue(String value) {
    return RecurringOrderActivatePeriodEndDateEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError(
        'Invalid RecurringOrderActivatePeriodEndDateEnum value: $value',
      ),
    );
  }
}
