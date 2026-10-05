import '../strategies/supplier_status_strategy.dart';

enum SupplierStatusEnum {
  online('online'),
  away('away'),
  offline('offline');

  final String _value;

  const SupplierStatusEnum(this._value);

  @override
  String toString() => _value;

  static SupplierStatusEnum fromValue(String value) {
    return SupplierStatusEnum.values.firstWhere(
      (element) => element._value == value,
      orElse: () => SupplierStatusEnum.away,
    );
  }

  static SupplierStatusStrategy getStrategy(SupplierStatusEnum type) {
    switch (type) {
      case SupplierStatusEnum.online:
        return OnlineSupplierStatusStrategy();
      case SupplierStatusEnum.away:
        return AwaySupplierStatusStrategy();
      case SupplierStatusEnum.offline:
        return OfflineSupplierStatusStrategy();
    }
  }
}
