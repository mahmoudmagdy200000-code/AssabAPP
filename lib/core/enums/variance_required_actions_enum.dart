import '../../features/receive_goods/domain/strategies/variance_required_actions_strategy.dart';

enum VarianceRequiredActionsEnum {
  acceptAsIs('accept'),
  createCompensatoryOrder('compensatory_order'),
  deductFromInvoiceValue('deduct_from_invoice');

  final String _value;

  const VarianceRequiredActionsEnum(this._value);

  String get value => _value;

  static VarianceRequiredActionsEnum fromValue(String value) {
    return VarianceRequiredActionsEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VarianceRequiredActionsEnum.acceptAsIs,
    );
  }

  static VarianceRequiredActionsStrategy getStrategy(
    VarianceRequiredActionsEnum value,
  ) {
    switch (value) {
      case VarianceRequiredActionsEnum.acceptAsIs:
        return AcceptAsIsVarianceRequiredActionsStrategy();
      case VarianceRequiredActionsEnum.createCompensatoryOrder:
        return CreateCompensatoryOrderVarianceRequiredActionsStrategy();
      case VarianceRequiredActionsEnum.deductFromInvoiceValue:
        return DeductFromInvoiceValueVarianceRequiredActionsStrategy();
    }
  }
}
