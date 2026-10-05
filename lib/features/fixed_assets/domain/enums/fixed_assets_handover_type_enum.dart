enum FixedAssetsHandoverTypeEnum {
  sender('sender'),
  receiver('receiver');

  final String _value;

  const FixedAssetsHandoverTypeEnum(this._value);

  String get value => _value;

  static FixedAssetsHandoverTypeEnum fromString(String value) {
    return FixedAssetsHandoverTypeEnum.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError(
        'Invalid FixedAssetsHandoverTypeEnum value: $value',
      ),
    );
  }
}
