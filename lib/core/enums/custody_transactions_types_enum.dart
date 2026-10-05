enum CustodyTransactionsTypesEnum {
  non('Non'),
  all('All'),
  cashHandover('Cash_Handover'),
  bankTransfer('Bank_Transfer'),
  custodyRequests('Custody_Requests');

  final String _value;

  const CustodyTransactionsTypesEnum(this._value);

  String get value => _value;

  static CustodyTransactionsTypesEnum fromValue(String value) {
    return CustodyTransactionsTypesEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CustodyTransactionsTypesEnum.non,
    );
  }
}
