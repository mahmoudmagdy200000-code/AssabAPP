import '../../../../domain/entity/shift/variance_details/variance_other_cashier_entity.dart';
import '../../../model/shift/shift_details/variance/variance_data_model.dart';

extension VarianceOtherCashierMapper on VarianceOtherCashierModel {
  VarianceOtherCashierEntity toEntity() => VarianceOtherCashierEntity(
    amount: amount,
    cashierId: cashierId,
    cashierName: cashierName,
    notes: notes,
  );
}
