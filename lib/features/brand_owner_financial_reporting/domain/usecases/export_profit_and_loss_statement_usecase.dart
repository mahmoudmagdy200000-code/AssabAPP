import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../repositories/brand_owner_profit_and_loss_statement_repository.dart';

@LazySingleton()
class ExportProfitAndLossStatementUseCase {
  final BrandOwnerProfitAndLossStatementRepository _repository;

  ExportProfitAndLossStatementUseCase(this._repository);

  Future<ApiResult<void>> emailReport({
    required int year,
    required int month,
    required String branchId,
    required String email,
  }) {
    return _repository.emailProfitAndLossStatement(
      year: year,
      month: month,
      branchId: branchId,
      email: email,
    );
  }

  Future<ApiResult<String>> call({
    required int year,
    required int month,
    required String branchId,
    required String formatType,
  }) {
    return _repository.exportProfitAndLossStatement(
      year: year,
      month: month,
      branchId: branchId,
      formatType: formatType,
    );
  }
}
