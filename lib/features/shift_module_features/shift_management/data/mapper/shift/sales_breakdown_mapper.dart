import 'package:assab/features/shift_module_features/shift_management/domain/entity/sales_breakdown_entity.dart';

import '../../model/shift/shift_details/shift_details_model.dart';

extension SalesBreakdownMapper on SalesBreakDownModel {
  SalesBreakdownEntity toEntity() {
    return SalesBreakdownEntity(
      id: id,
      aggregatorName: aggregator,
      amount: double.tryParse((amount ?? 0).toString()) ?? 0,
    );
  }
}
