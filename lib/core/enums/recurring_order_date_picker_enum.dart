enum RecurringOrderDatePickerEnum {
  d1st(1),
  d2nd(2),
  d3rd(3),
  d4th(4),
  d5th(5),
  d6th(6),
  d7th(7),
  d8th(8),
  d9th(9),
  d10th(10),
  d11th(11),
  d12th(12),
  d13th(13),
  d14th(14),
  d15th(15),
  d16th(16),
  d17th(17),
  d18th(18),
  d19th(19),
  d20th(20),
  d21st(21),
  d22nd(22),
  d23rd(23),
  d24th(24),
  d25th(25),
  d26th(26),
  d27th(27),
  d28th(28),
  d29th(29),
  d30th(30),
  d31st(31);

  final int _value;

  const RecurringOrderDatePickerEnum(this._value);

  int get value => _value;

  static RecurringOrderDatePickerEnum fromValue(int value) {
    return RecurringOrderDatePickerEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError(
        'Invalid RecurringOrderDatePickerEnum value: $value',
      ),
    );
  }

  String get label {
    switch (this) {
      case RecurringOrderDatePickerEnum.d1st:
        return '1st';
      case RecurringOrderDatePickerEnum.d2nd:
        return '2nd';
      case RecurringOrderDatePickerEnum.d3rd:
        return '3rd';
      case RecurringOrderDatePickerEnum.d4th:
        return '4th';
      case RecurringOrderDatePickerEnum.d5th:
        return '5th';
      case RecurringOrderDatePickerEnum.d6th:
        return '6th';
      case RecurringOrderDatePickerEnum.d7th:
        return '7th';
      case RecurringOrderDatePickerEnum.d8th:
        return '8th';
      case RecurringOrderDatePickerEnum.d9th:
        return '9th';
      case RecurringOrderDatePickerEnum.d10th:
        return '10th';
      case RecurringOrderDatePickerEnum.d11th:
        return '11th';
      case RecurringOrderDatePickerEnum.d12th:
        return '12th';
      case RecurringOrderDatePickerEnum.d13th:
        return '13th';
      case RecurringOrderDatePickerEnum.d14th:
        return '14th';
      case RecurringOrderDatePickerEnum.d15th:
        return '15th';
      case RecurringOrderDatePickerEnum.d16th:
        return '16th';
      case RecurringOrderDatePickerEnum.d17th:
        return '17th';
      case RecurringOrderDatePickerEnum.d18th:
        return '18th';
      case RecurringOrderDatePickerEnum.d19th:
        return '19th';
      case RecurringOrderDatePickerEnum.d20th:
        return '20th';
      case RecurringOrderDatePickerEnum.d21st:
        return '21st';
      case RecurringOrderDatePickerEnum.d22nd:
        return '22nd';
      case RecurringOrderDatePickerEnum.d23rd:
        return '23rd';
      case RecurringOrderDatePickerEnum.d24th:
        return '24th';
      case RecurringOrderDatePickerEnum.d25th:
        return '25th';
      case RecurringOrderDatePickerEnum.d26th:
        return '26th';
      case RecurringOrderDatePickerEnum.d27th:
        return '27th';
      case RecurringOrderDatePickerEnum.d28th:
        return '28th';
      case RecurringOrderDatePickerEnum.d29th:
        return '29th';
      case RecurringOrderDatePickerEnum.d30th:
        return '30th';
      case RecurringOrderDatePickerEnum.d31st:
        return '31st';
    }
  }
}
