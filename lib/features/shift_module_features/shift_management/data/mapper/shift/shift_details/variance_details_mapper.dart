import '../../../../domain/entity/shift/vaiance_details_entity.dart';
import '../../../model/shift/shift_details/variance_details_model.dart';

extension VarianceDetailsMapper on VarianceDetailsModel {
  VarianceDetailsEntity toEntity() {
    return VarianceDetailsEntity(
      id: id,
      responsibleCashier: responsibleCashier,
      amount: amount,
      reason: reason,
    );
  }
}
