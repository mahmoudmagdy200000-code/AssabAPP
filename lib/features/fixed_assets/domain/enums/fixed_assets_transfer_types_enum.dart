enum FixedAssetsTransferTypesEnum {
  fromBranch('from_branch'),
  fromFinance('from_finance'),
  toBranch('to_branch');

  final String _value;

  const FixedAssetsTransferTypesEnum(this._value);

  String get value => _value;
}
