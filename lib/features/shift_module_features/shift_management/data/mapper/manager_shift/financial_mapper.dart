import '../../../domain/entity/manager_shift/current_shift/financial_entity.dart';
import '../../model/manager_shift_management_models/financial_summary.dart';

extension FinancialMapper on FinancialSummary {
  FinancialEntity toEntity() => FinancialEntity(
    totalSales: totalSales,
    netSales: netSales,
    vatAmount: vatAmount,
    cashCollected: cashCollected,
    cardPayments: cardPayments,
    aggregatorPayments: aggregatorPayments,
  );
}
