import 'package:assab/features/shift_module_features/shift_management/data/model/shift/available_cashiers_response_model.dart';

import '../../../domain/entity/shift/available_cashier_entity.dart';

extension AvailableCashiersMapper on AvailableCashier {
  AvailableCashierEntity toEntity() => AvailableCashierEntity(
    id: id,
    name: name,
    image: image,
    isAvailable: isAvailable,
  );
}
