enum InventoryStatusEnum {
  pending('pending'),
  completed('completed'),
  approved('approved'),
  rejected('rejected');

  final String _value;

  const InventoryStatusEnum(this._value);

  String get value => _value;

  static InventoryStatusEnum fromString(String value) {
    return InventoryStatusEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid inventory status: $value'),
    );
  }
}
