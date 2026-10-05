enum UserType {
  cashier('cashier'),
  manager('branch_manager');

  final String _value;

  const UserType(this._value);

  String get value => _value;

  static UserType fromJson(String? value) {
    switch (value?.toLowerCase()) {
      case 'cashier':
        return UserType.cashier;
      case 'branch_manager':
      case 'branch manager':
        return UserType.manager;
      default:
        return UserType.cashier;
    }
  }
}
