import '../../../../core/utils/future_api_result.dart';
import '../entities/profit_vs_cash_reconciliation_entity.dart';

abstract class BrandOwnerProfitVsCashReconciliationRepository {
  FutureApiResult<ProfitVsCashReconciliationEntity>
      getProfitVsCashReconciliation();

  FutureApiResult<String> exportProfitVsCashReconciliation({
    required String formatType,
  });

  FutureApiResult<void> emailProfitVsCashReconciliation({
    required String email,
  });
}
