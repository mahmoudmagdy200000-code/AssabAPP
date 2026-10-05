enum FixedAssetsSearchType {
  general('general'),
  quick('quick');

  final String _value;

  const FixedAssetsSearchType(this._value);

  String get value => _value;
}
