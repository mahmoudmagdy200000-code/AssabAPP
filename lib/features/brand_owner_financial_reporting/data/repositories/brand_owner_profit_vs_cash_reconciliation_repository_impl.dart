import 'package:injectable/injectable.dart';

import '../../../../core/errors/repository_mixin.dart';
import '../../../../core/utils/future_api_result.dart';
import '../../domain/entities/profit_vs_cash_reconciliation_entity.dart';
import '../../domain/repositories/brand_owner_profit_vs_cash_reconciliation_repository.dart';
import '../datasources/brand_owner_profit_vs_cash_reconciliation_data_source.dart';
import '../models/export_profit_vs_cash_reconciliation_request.dart';

@LazySingleton(
  as: BrandOwnerProfitVsCashReconciliationRepository,
)
class BrandOwnerProfitVsCashReconciliationRepositoryImpl
    with RepositoryMixin
    implements BrandOwnerProfitVsCashReconciliationRepository {
  final BrandOwnerProfitVsCashReconciliationDataSource _dataSource;

  BrandOwnerProfitVsCashReconciliationRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<ProfitVsCashReconciliationEntity>
      getProfitVsCashReconciliation() {
    return execute(() async {
      return await _dataSource.getProfitVsCashReconciliation();
    });
  }

  @override
  FutureApiResult<String> exportProfitVsCashReconciliation({
    required String formatType,
  }) {
    return execute(() async {
      return await _dataSource.exportProfitVsCashReconciliation(
        request: ExportProfitVsCashReconciliationRequest(
          formatType: formatType,
        ),
      );
    });
  }

  @override
  FutureApiResult<void> emailProfitVsCashReconciliation({
    required String email,
  }) {
    return execute(() async {
      return await _dataSource.emailProfitVsCashReconciliation(
        request: ExportProfitVsCashReconciliationRequest(
          formatType: 'pdf',
          email: email,
        ),
      );
    });
  }
}
