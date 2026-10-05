enum ShiftStatusType {
  pending('not_started'),
  reassigned('reassigned'),
  inProgress('in_progress'),
  completed('completed'),
  all('all');

  final String _value;

  const ShiftStatusType(this._value);

  String get value => _value;

  static ShiftStatusType fromString(String value) {
    return ShiftStatusType.values.firstWhere(
      (e) => e.value.toString() == value.toString(),
      orElse: () => ShiftStatusType.all,
    );
  }
}
