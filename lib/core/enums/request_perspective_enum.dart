enum RequestPerspectiveEnum {
  non('non'),
  all('all'),
  iSubmitted('submitted'),
  iReceived('received');

  final String _value;

  const RequestPerspectiveEnum(this._value);

  @override
  String toString() => _value;
}
