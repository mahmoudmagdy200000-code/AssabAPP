import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../repositories/brand_owner_profit_vs_cash_reconciliation_repository.dart';

@LazySingleton()
class ExportProfitVsCashReconciliationUseCase {
  final BrandOwnerProfitVsCashReconciliationRepository _repository;

  ExportProfitVsCashReconciliationUseCase(this._repository);

  Future<ApiResult<String>> call({
    required String formatType,
  }) {
    return _repository.exportProfitVsCashReconciliation(
      formatType: formatType,
    );
  }

  Future<ApiResult<void>> emailReport({
    required String email,
  }) {
    return _repository.emailProfitVsCashReconciliation(
      email: email,
    );
  }
}
