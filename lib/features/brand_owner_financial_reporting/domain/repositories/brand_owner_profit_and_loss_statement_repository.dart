import '../../../../core/utils/future_api_result.dart';
import '../entities/brand_owner_branch_entity.dart';
import '../entities/profit_and_loss_statement_entity.dart';

abstract class BrandOwnerProfitAndLossStatementRepository {
  FutureApiResult<ProfitAndLossStatementEntity> getProfitAndLossStatement({
    int? year,
    int? month,
    String? branchId,
  });

  FutureApiResult<String> exportProfitAndLossStatement({
    required int year,
    required int month,
    required String branchId,
    required String formatType,
  });

  FutureApiResult<List<BrandOwnerBranchEntity>> getBranches();

  FutureApiResult<void> emailProfitAndLossStatement({
    required int year,
    required int month,
    required String branchId,
    required String email,
  });
}
