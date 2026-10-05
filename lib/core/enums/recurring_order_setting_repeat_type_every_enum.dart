enum RecurringOrderSettingRepeatTypeEveryEnum {
  oneSt(1),
  twoNd(2),
  threeRd(3),
  fourTh(4),
  fiveTh(5);

  final int _value;

  const RecurringOrderSettingRepeatTypeEveryEnum(this._value);

  int get value => _value;

  static RecurringOrderSettingRepeatTypeEveryEnum fromValue(int value) {
    return RecurringOrderSettingRepeatTypeEveryEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError(
        'Invalid RecurringOrderSettingRepeatTypeEveryEnum value: $value',
      ),
    );
  }

  String get label {
    switch (this) {
      case RecurringOrderSettingRepeatTypeEveryEnum.oneSt:
        return '1st';
      case RecurringOrderSettingRepeatTypeEveryEnum.twoNd:
        return '2nd';
      case RecurringOrderSettingRepeatTypeEveryEnum.threeRd:
        return '3rd';
      case RecurringOrderSettingRepeatTypeEveryEnum.fourTh:
        return '4th';
      case RecurringOrderSettingRepeatTypeEveryEnum.fiveTh:
        return '5th';
    }
  }
}
