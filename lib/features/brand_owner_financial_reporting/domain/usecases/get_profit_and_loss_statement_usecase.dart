import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/profit_and_loss_statement_entity.dart';
import '../repositories/brand_owner_profit_and_loss_statement_repository.dart';

@LazySingleton()
class GetProfitAndLossStatementUseCase {
  final BrandOwnerProfitAndLossStatementRepository _repository;

  GetProfitAndLossStatementUseCase(this._repository);

  Future<ApiResult<ProfitAndLossStatementEntity>> call({
    int? year,
    int? month,
    String? branchId,
  }) {
    return _repository.getProfitAndLossStatement(
      year: year,
      month: month,
      branchId: branchId,
    );
  }
}
