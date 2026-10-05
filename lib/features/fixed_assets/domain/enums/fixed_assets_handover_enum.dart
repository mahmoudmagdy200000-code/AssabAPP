enum FixedAssetsHandoverEnum {
  pendingApproval('pending_approval'),
  pending('pending'),
  completed('completed');

  final String _value;

  const FixedAssetsHandoverEnum(this._value);

  String get value => _value;

  static FixedAssetsHandoverEnum fromString(String value) {
    return FixedAssetsHandoverEnum.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Invalid handover status: $value'),
    );
  }
}
