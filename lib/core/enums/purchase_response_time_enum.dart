enum PurchaseResponseTimeEnum {
  non('non'),
  fast('fast'),
  normal('normal'),
  slow('slow');

  final String _value;

  const PurchaseResponseTimeEnum(this._value);

  String get value => _value;
}
