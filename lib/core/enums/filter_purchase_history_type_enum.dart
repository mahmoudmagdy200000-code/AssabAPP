enum FilterPurchaseHistoryTypeEnum {
  non('non'),
  all('all'),
  branchTransfer('internal_transfer'),
  purchasingOfficer('via_purchasing_officer'),
  directSupplier('direct_supplier');

  final String _value;

  const FilterPurchaseHistoryTypeEnum(this._value);

  String get value => _value;
}
