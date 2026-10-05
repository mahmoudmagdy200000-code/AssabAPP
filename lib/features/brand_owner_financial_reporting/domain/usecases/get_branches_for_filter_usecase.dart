import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/brand_owner_branch_entity.dart';
import '../repositories/brand_owner_profit_and_loss_statement_repository.dart';

@LazySingleton()
class GetBranchesForFilterUseCase {
  final BrandOwnerProfitAndLossStatementRepository _repository;

  GetBranchesForFilterUseCase(this._repository);

  Future<ApiResult<List<BrandOwnerBranchEntity>>> call() {
    return _repository.getBranches();
  }
}
