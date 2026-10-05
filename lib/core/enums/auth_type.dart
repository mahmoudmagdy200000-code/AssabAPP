enum AuthType {
  email('email'),
  phone('phone');

  final String _value;

  const AuthType(this._value);

  String get value => _value;
}
