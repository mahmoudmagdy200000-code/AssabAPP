enum SelectBranchManagerDeliveryTimeEnum {
  non('non'),
  min30('30_min'),
  hour1('1_hour'),
  hour2('2_hours'),
  hour3('3_hours_or_more');

  final String _value;

  const SelectBranchManagerDeliveryTimeEnum(this._value);

  String get value => _value;

  static SelectBranchManagerDeliveryTimeEnum fromValue(String value) {
    return SelectBranchManagerDeliveryTimeEnum.values.firstWhere(
      (element) => element.value == value,
      orElse: () => SelectBranchManagerDeliveryTimeEnum.non,
    );
  }
}
