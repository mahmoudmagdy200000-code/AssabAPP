import '../models/export_profit_vs_cash_reconciliation_request.dart';
import '../models/profit_vs_cash_reconciliation_model.dart';

abstract class BrandOwnerProfitVsCashReconciliationDataSource {
  Future<ProfitVsCashReconciliationModel> getProfitVsCashReconciliation();

  Future<String> exportProfitVsCashReconciliation({
    required ExportProfitVsCashReconciliationRequest request,
  });

  Future<void> emailProfitVsCashReconciliation({
    required ExportProfitVsCashReconciliationRequest request,
  });
}
