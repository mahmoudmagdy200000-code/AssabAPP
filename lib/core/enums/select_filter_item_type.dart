enum SelectFilterItemType {
  category('category'),
  supplier('supplier');

  final String _value;

  const SelectFilterItemType(this._value);

  String get value => _value;
}
