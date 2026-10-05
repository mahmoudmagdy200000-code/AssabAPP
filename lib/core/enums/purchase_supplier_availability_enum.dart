enum PurchaseSupplierAvailabilityEnum {
  non('non'),
  all('all'),
  online('online'),
  away('away'),
  offline('offline');

  final String _value;

  const PurchaseSupplierAvailabilityEnum(this._value);

  @override
  String toString() => _value;
}
