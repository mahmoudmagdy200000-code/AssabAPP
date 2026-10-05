enum NewExpectedDeliveryDateType {
  today('today'),
  custom('custom');

  final String _value;

  const NewExpectedDeliveryDateType(this._value);

  String get value => _value;

  static NewExpectedDeliveryDateType fromString(String value) {
    return NewExpectedDeliveryDateType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NewExpectedDeliveryDateType.custom,
    );
  }
}
