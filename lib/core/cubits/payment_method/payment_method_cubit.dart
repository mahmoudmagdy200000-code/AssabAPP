import 'package:assab/features/branch_manager_expenses/data/models/supplier_model.dart';
import 'package:injectable/injectable.dart';

import '../../enums/payment_method.dart';
import '../../helpers/safe_cubit.dart';
import 'payment_method_state.dart';

@injectable
class PaymentMethodCubit extends SafeCubit<PaymentMethodState> {
  PaymentMethodCubit() : super(const PaymentMethodState());

  void selectMethod(PaymentMethod method) {
    emit(
      state.copyWith(
        selectedMethod: method,
        isSupplierCreditExpanded: method == PaymentMethod.supplier
            ? true
            : state.isSupplierCreditExpanded,
        supplier: null,
      ),
    );
  }

  void toggleSupplierCreditExpand() {
    emit(
      state.copyWith(isSupplierCreditExpanded: !state.isSupplierCreditExpanded),
    );
  }

  void selectSupplier(SupplierModel supplier) {
    emit(state.copyWith(supplier: supplier));
  }

  void clearSelection() {
    emit(
      state.copyWith(
        selectedMethod: null,
        supplier: null,
        isSupplierCreditExpanded: false,
      ),
    );
  }
}
