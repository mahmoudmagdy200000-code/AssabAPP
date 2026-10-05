import 'package:assab/features/branch_manager_expenses/data/models/supplier_model.dart';
import 'package:equatable/equatable.dart';

import '../../enums/payment_method.dart';

class PaymentMethodState extends Equatable {
  final PaymentMethod? selectedMethod;
  final bool isSupplierCreditExpanded;
  final SupplierModel? supplier;

  const PaymentMethodState({
    this.selectedMethod,
    this.isSupplierCreditExpanded = false,
    this.supplier,
  });

  PaymentMethodState copyWith({
    PaymentMethod? selectedMethod,
    bool? isSupplierCreditExpanded,
    SupplierModel? supplier,
  }) {
    return PaymentMethodState(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      isSupplierCreditExpanded:
          isSupplierCreditExpanded ?? this.isSupplierCreditExpanded,
      supplier: supplier ?? this.supplier,
    );
  }

  @override
  List<Object?> get props => [
    selectedMethod,
    isSupplierCreditExpanded,
    supplier,
  ];
}
