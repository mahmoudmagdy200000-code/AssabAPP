enum FixedAssetsQuickSearchType {
  updateToday('update_today'),
  updateYesterday('update_yesterday'),
  notUpdate1Month('not_update_1_month'),
  notUpdate2Month('not_update_2_month'),
  inMyCustody('in_my_custody'),
  underMaintenance('under_maintenance'),
  non('non');

  final String _value;

  const FixedAssetsQuickSearchType(this._value);

  String get value => _value;
}
