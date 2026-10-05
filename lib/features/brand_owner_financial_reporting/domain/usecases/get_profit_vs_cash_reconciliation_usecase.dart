import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/profit_vs_cash_reconciliation_entity.dart';
import '../repositories/brand_owner_profit_vs_cash_reconciliation_repository.dart';

@LazySingleton()
class GetProfitVsCashReconciliationUseCase {
  final BrandOwnerProfitVsCashReconciliationRepository _repository;

  GetProfitVsCashReconciliationUseCase(this._repository);

  Future<ApiResult<ProfitVsCashReconciliationEntity>> call() {
    return _repository.getProfitVsCashReconciliation();
  }
}
