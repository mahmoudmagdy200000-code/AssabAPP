enum RequestsOrdersTypesEnum {
  order('order'),
  request('request');

  final String _value;

  const RequestsOrdersTypesEnum(this._value);

  String get value => _value;

  static RequestsOrdersTypesEnum fromString(String value) {
    return RequestsOrdersTypesEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RequestsOrdersTypesEnum.order,
    );
  }
}
