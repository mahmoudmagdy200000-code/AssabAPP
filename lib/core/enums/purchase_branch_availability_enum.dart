enum PurchaseBranchAvailabilityEnum {
  non('non'),
  all('all'),
  mod60('60'),
  mod70('70'),
  mod80('80'),
  mod90('90'),
  mod100('100');

  final String _value;

  const PurchaseBranchAvailabilityEnum(this._value);

  String get value => _value;
}
