import '../models/brand_owner_branch_model.dart';
import '../models/export_profit_and_loss_request.dart';
import '../models/profit_and_loss_statement_model.dart';

abstract class BrandOwnerProfitAndLossStatementDataSource {
  Future<ProfitAndLossStatementModel> getProfitAndLossStatement({
    int? year,
    int? month,
    String? branchId,
  });

  Future<String> exportProfitAndLossStatement({
    required ExportProfitAndLossRequest request,
  });

  Future<void> emailProfitAndLossStatement({
    required ExportProfitAndLossRequest request,
  });

  Future<List<BrandOwnerBranchModel>> getBranches();
}
