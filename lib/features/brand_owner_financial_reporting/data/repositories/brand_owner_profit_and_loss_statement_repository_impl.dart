import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../domain/entities/brand_owner_branch_entity.dart';
import '../../domain/entities/profit_and_loss_statement_entity.dart';
import '../../domain/repositories/brand_owner_profit_and_loss_statement_repository.dart';
import '../datasources/brand_owner_profit_and_loss_statement_data_source.dart';
import '../models/export_profit_and_loss_request.dart';

@LazySingleton(as: BrandOwnerProfitAndLossStatementRepository)
class BrandOwnerProfitAndLossStatementRepositoryImpl
    with RepositoryMixin
    implements BrandOwnerProfitAndLossStatementRepository {
  final BrandOwnerProfitAndLossStatementDataSource _dataSource;

  BrandOwnerProfitAndLossStatementRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<ProfitAndLossStatementEntity> getProfitAndLossStatement({
    int? year,
    int? month,
    String? branchId,
  }) {
    return execute(() async {
      return await _dataSource.getProfitAndLossStatement(
        year: year,
        month: month,
        branchId: branchId,
      );
    });
  }

  @override
  FutureApiResult<String> exportProfitAndLossStatement({
    required int year,
    required int month,
    required String branchId,
    required String formatType,
  }) {
    return execute(() async {
      return await _dataSource.exportProfitAndLossStatement(
        request: ExportProfitAndLossRequest(
          year: year,
          month: month,
          branchId: branchId,
          formatType: formatType,
        ),
      );
    });
  }

  @override
  FutureApiResult<void> emailProfitAndLossStatement({
    required int year,
    required int month,
    required String branchId,
    required String email,
  }) {
    return execute(() async {
      return await _dataSource.emailProfitAndLossStatement(
        request: ExportProfitAndLossRequest(
          year: year,
          month: month,
          branchId: branchId,
          formatType: 'pdf',
          email: email,
        ),
      );
    });
  }

  @override
  FutureApiResult<List<BrandOwnerBranchEntity>> getBranches() {
    return execute(() async {
      return await _dataSource.getBranches();
    });
  }
}
